class ItemsController < ApplicationController
	inherit_resources

	# impressionist #comment out this line when impressionist method created in each action

	before_filter :authenticate_user!, except: [:index, :show]
	before_filter :load_itemizable, except: [:index, :new, :create, :autocomplete_brand_name, :logs]
	helper_method :sort_column, :sort_direction  
	autocomplete :brand, :name

	private
	MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]


	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		MOBILE_BROWSERS.each do |m|
			if agent.match(m) && (agent == "android")
				#puts "android detected" 
				@android_detected = true
			end
		end
	end

	# GET /items/1
	# GET /items/1.json
	def index
		cards_per_page = 16

		if @itemizable.present?
			@items = @itemizable.items
		else
			if (params[:order].present?) && (params[:order] == "popular")
				@items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("view_count DESC").page(params[:page]).per_page(cards_per_page)
			elsif (params[:order] == "popular_weekly")
				@items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").page(params[:page]).per_page(cards_per_page)
			elsif user_signed_in? && current_user.can_create?(Item)
				@items = Item.order("created_at DESC").page(params[:page]).per_page(cards_per_page)
			else
				@items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("created_at DESC").page(params[:page]).per_page(cards_per_page)
			end
			
		end

		@categories = Item.joins(:categories).where("parent_id IS NULL ").all
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @items }
		end

	end

	def logs
		cards_per_page = 16
		if params[:order].nil? or params[:order] == "view_count"
			@items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at BETWEEN ? AND ?)", params[:search_from], params[:search_to]).group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").page(params[:page]).per_page(cards_per_page)
		elsif params[:order] == "comment_count"
			@items = Item.joins("JOIN comments ON comments.commentable_id = items.id").where("comments.commentable_type = 'Item' ").group("comments.commentable_id").order("count(comments.commentable_id) DESC").page(params[:page]).per_page(cards_per_page)
		elsif params[:order] == "bookmark_count"
			#@items = Item.joins("JOIN bookmarks ON bookmarks.bookmarkable_id = items.id").where("bookmarks.bookmarkable_type = 'Item' ").group("bookmarks.bookmarkable_id").order("count(bookmarks.bookmarkable_id) DESC").page(params[:page]).per_page(cards_per_page)
			@items = Item.joins("JOIN bookmarks ON bookmarks.model_id = items.id").where("bookmarks.model_type_id = 1 ").group("bookmarks.model_id").order("count(bookmarks.model_id) DESC").page(params[:page]).per_page(cards_per_page)
		else 
			@items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' ").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").page(params[:page]).per_page(cards_per_page)
		end


		@categories = Item.joins(:categories).where("parent_id IS NULL ").all
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @items }
		end
	end

	def new
		if @itemizable.present?
			@item = @itemizable.items.new
		else
			@item = Item.new
		end    
	end
	
	def create
		#new & save시에는 itemization 이 creation되지 않
		#@item = @itemizable.items.new(params[:item])

		# 아래는 find_or_create_by 메소드를 구현한 것, 현재는 model에서 동작함
=begin
		@item = Item.find_by_name(params[:item][:name])
		if @item.present? 
			itemization = @itemizable.itemizations.find_by_item_id(@item.id) || @itemizable.itemizations.create(item_id: @item.id) 
		else
			@item = @itemizable.items.create(params[:item])
		end
=end
		@item = Item.new(params[:item])
		if @item.save
			if @itemizable
				redirect_to @itemizable, notice: "Item created."
			else
				redirect_to @item, notice: "Item created."
			end
		else
			render :new
		end
	end

	def show
		@item = Item.find(params[:id])

		@tutorials = @item.tutorials
		@videos = @item.videos

		@pictureable = @item
		@pictures = @pictureable.pictures
		@picture = Picture.new
		
		p_cat_ids = Array.new
		@item.categories.each do |cat|
			p_cat_ids.push(cat.parent.id) if cat.parent
		end
		sibling_categories = Category.where("parent_id IN (?)", p_cat_ids)
		@parent_categories = Category.where("id IN (?)", p_cat_ids)
		#p_categories = Category.where("id IN (?)", .map(&:id)).praent

		@items_in_tutorial = @tutorials.order("view_count DESC").first.items.where("item_id <> ?", @item.id).order("view_count DESC").limit(5) if @item.tutorials.present?
		item_ids_in_category = Item.joins(:categories).where("category_id IN (?) AND items.id <> ?", sibling_categories.map(&:id), @item.id).select("distinct(items.id)")#.order("items.view_count DESC")
		@items_in_category = Item.where("id IN (?)", item_ids_in_category.map(&:id)).order("view_count DESC")
		
		@commentable = @item
		comments_per_page = 7
		page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
		@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

		if user_signed_in?
			@comment = @commentable.comments.new(user_id: current_user.id)
			@comment.build_picture 
		else
			@comment = Comment.new
		end

		#if cannot? :manage, @item
		if !(user_signed_in? && current_user.can_update?(@item))
			@item.increment_view_count 
			impressionist(@item) #, "", :unique => [:session_hash]) 동일 세션에서도 reload시 count함(2014/06/29)
		end

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @item }
		end
	end

	def destroy
		@item = @itemizable.items.find(params[:id])
		@item.destroy

		respond_to do |format|
			format.html { redirect_to @itemizable }
			format.json { head :no_content }
		end
	end  

	def unitemize 
		puts "params[:id] : #{params[:item_id]}"
		@item = @itemizable.items.find(params[:item_id])
		itemization = @itemizable.itemizations.find_by_item_id(@item.id)
		itemization.destroy

		redirect_to @itemizable

	end

	def featured
		puts "params[:id] : #{params[:item_id]}"
		@item = @itemizable.items.find(params[:item_id])
		itemization = @itemizable.itemizations.find_by_item_id(@item.id)
		itemization.featured = true
		itemization.save

		redirect_to @itemizable

	end

	def unfeatured
		puts "params[:id] : #{params[:item_id]}"
		@item = @itemizable.items.find(params[:item_id])
		itemization = @itemizable.itemizations.find_by_item_id(@item.id)
		itemization.featured = false
		itemization.save

		redirect_to @itemizable

	end

	private
	def load_itemizable
		resource, id = request.path.split('/')[1,2]
		@itemizable = resource.singularize.classify.constantize.find(id)
	end
  
	def sort_column  
		params[:sort] || "name"  
	end  
		
	def sort_direction  
		params[:direction] || "asc"  
	end  
end
