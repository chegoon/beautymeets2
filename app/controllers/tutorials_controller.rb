class TutorialsController < ApplicationController
	inherit_resources
	
	#impressionist #:actions=>[:show]  #comment out this line when impressionist method created in each action
	
	# Load authorizing from cancan
	# load_and_authorize_resource

	# authorize controller thourgh authority
	# autocomplete_item_name을 적어주지 않을 경우, authority missing action이 발생
	authorize_actions_for Tutorial, except: [:index, :show, :autocomplete_item_name, :autocomplete_collection_title]

	respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  

	autocomplete :item, :name
	autocomplete :collection, :title
		
	before_filter :detect_browser

	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		@android_detected = true if agent.include? "android" 
	end

	# GET /tutorials
	# GET /tutorials.json
	def index
		cards_per_page = 11

		if (params[:cond].present?) && (params[:cond] == "uncategorized")
				@tutorials = Tutorial.where("id NOT in (?) and published=TRUE", Tutorial.joins(:categories).map(&:id)).order("creatd_at DESC").page(params[:page]).per_page(cards_per_page)
		elsif (params[:order].present?) && (params[:order] == "popular")
				@tutorials = Tutorial.where("published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
		elsif (params[:order] == "popular_weekly")
				@tutorials = Tutorial.joins("JOIN impressions ON impressions.impressionable_id = tutorials.id").where("impressions.impressionable_type = 'Tutorial' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").page(params[:page]).per_page(cards_per_page)        
		else      
				@tutorials = Tutorial.where("published=TRUE").order("created_at DESC").page(params[:page]).per_page(cards_per_page)
		end
		@categories = Tutorial.joins(:categories).where("parent_id IS NULL ").all
		@head_tutorial = @tutorials.sample(1).first

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @tutorials }
			format.js
		end
	end

	def show
		@tutorial = Tutorial.find(params[:id])
		
		@pictureable = @tutorial
		@pictures = @pictureable.pictures
		@picture = Picture.new

		@itemizable = @tutorial
		@items = @itemizable.items
		@featured_items = @tutorial.itemizations.where(featured: true).present? ? Item.where("id IN (?)", @tutorial.itemizations.where(featured: true).map(&:item_id)) : @tutorial.items.sample(1)
		@item = Item.new

		@collectable = @tutorial
		@collections = @collectable.collections

		@tutorials = Tutorial.where("id != ? AND published=TRUE", @tutorial.id).order("created_at DESC").limit(3)
		@videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("created_at DESC").limit(10).sample(4)

		#if (cannot? :author, @tutorial) || (cannot? :manage, Tutorial)
		if !(user_signed_in? && current_user.can_update?(@tutorial))
			@tutorial.increment_view_count 
			impressionist(@tutorial) #, "", :unique => [:session_hash]) 동일 세션에서도 reload시 count함(2014/06/05)
		end

		@commentable = @tutorial
		#@comments = @commentable.root_comments.order("created_at ASC")
		comments_per_page = 7
		page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
		@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

		if user_signed_in?
			@comment = @commentable.comments.new(user_id: current_user.id)#Comment.build_from(@commentable, current_user.id, "", nil)
			@comment.build_picture #has_many가 될경우 @comment.pictures.build
			#@comment.pictures.build 
			@tutorial.mark_as_read! :for => current_user
		else
			@comment = Comment.new
		end

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @tutorial }
		end
	end

	# POST /tutorials
	# POST /tutorials.json
	def create
		@tutorial = current_user.tutorials.create(params[:tutorial])

		current_user.add_role :author, @tutorial
		#@tutorial = Beautorial.new(params[:tutorial])

		respond_to do |format|
			if @tutorial.save
				format.html { redirect_to @tutorial, notice: 'Tutorial was successfully created.' }
				format.json { render json: @tutorial, status: :created, location: @tutorial }
			else
				format.html { render action: "new" }
				format.json { render json: @tutorial.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@tutorial = Tutorial.find(params[:id])

		respond_to do |format|
			if @tutorial.update_attributes(params[:tutorial])
				#puts "p_a #{PublicActivity::Activity.where(owner_id: @tutorial.author.id, owner_type: 'User', trackable_id: @tutorial.id, trackable_type: 'Tutorial').first.present?}"
				if @tutorial.published? && PublicActivity::Activity.where(owner_id: @tutorial.author.id, owner_type: "User", trackable_id: @tutorial.id, trackable_type: "Tutorial").first.nil?
					@tutorial.create_activity :create, owner: @tutorial.author 
				end
				format.html { redirect_to @tutorial, notice: 'Tutorial was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @tutorial.errors, status: :unprocessable_entity }
			end
		end
	end
end
