class PostsController < InheritedResources::Base
	# Load authorizing from cancan
	#load_and_authorize_resource
	# authorize controller thourgh authority
	authorize_actions_for Post, except: [:index, :show, :autocomplete_collection_title]

	respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  

	autocomplete :item, :name
	autocomplete :collection, :title

	before_filter :detect_browser

	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		@android_detected = true if agent.include? "android" 
	end

	# GET /posts
	# GET /posts.json
	def index
		cards_per_page = 12

		if (params[:cond].present?) && (params[:cond] == "uncategorized")
				@posts = Post.where("id NOT in (?) and published=TRUE", Post.joins(:categories).map(&:id)).order("creatd_at DESC").page(params[:page]).per_page(cards_per_page)
		elsif (params[:order].present?) && (params[:order] == "popular")
				@posts = Post.where("published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
		elsif (params[:order] == "popular_weekly")
				@posts = Post.joins("JOIN impressions ON impressions.impressionable_id = posts.id").where("impressions.impressionable_type = 'Post' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").page(params[:page]).per_page(cards_per_page)        
		else      
				@posts = Post.where("published=TRUE").order("created_at DESC").page(params[:page]).per_page(cards_per_page)
		end

		@tutorials = Tutorial.where(published: true).order("view_count DESC").sample(5).first(2)
		
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @posts }
			format.js
		end
	end

	def show
		@post = Post.find(params[:id])
		
		@collectable = @post
		@collections = @collectable.collections

		@pictureable = @post
		@pictures = @pictureable.pictures
		@picture = Picture.new

		@tutorials = Tutorial.where(published: true).order("view_count DESC").sample(5).first(3)

		@post.increment_view_count 
		impressionist(@post)

		@commentable = @post
		comments_per_page = 7
		page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
		@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

		if user_signed_in?
			@comment = @commentable.comments.new(user_id: current_user.id)
			@comment.build_picture 
			@post.mark_as_read! :for => current_user
		else
			@comment = Comment.new
		end

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @post }
		end
	end

	# POST /posts
	# POST /posts.json
	def create
		@post = current_user.posts.create(params[:post])
		current_user.add_role :author, @post
		#@post = Beautorial.new(params[:post])

		respond_to do |format|
			if @post.save
				format.html { redirect_to @post, notice: 'Post was successfully created.' }
				format.json { render json: @post, status: :created, location: @post }
			else
				format.html { render action: "new" }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@post = Post.find(params[:id])

		respond_to do |format|
			if @post.update_attributes(params[:post])
				#@post.create_activity :create, owner: @post.author if @post.published? && PublicActivity::Activity.where(owner_id: @post.author.id, owner_type: "User", trackable_id: @post.id, trackable_type: "Post").nil?
				if @post.published? && PublicActivity::Activity.where(owner_id: @post.author.id, owner_type: "User", trackable_id: @post.id, trackable_type: "Post").first.nil?
					@post.create_activity :create, owner: @post.author 
				end
				format.html { redirect_to @post, notice: 'Post was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end
end
