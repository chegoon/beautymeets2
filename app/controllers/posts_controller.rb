class PostsController < InheritedResources::Base
	# Load authorizing from cancan
  #load_and_authorize_resource
  # authorize controller thourgh authority
  authorize_actions_for Post, except: [:index, :show]

  respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  

  autocomplete :item, :name
  
  # GET /posts
  # GET /posts.json
  def index
    cards_per_page = 12

    if (params[:order].present?) && (params[:order] == "popular")
      if params[:tag]
        @posts = Post.where("published=TRUE").order("view_count DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page)
      else
        @posts = Post.where("published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
      end
    else      
      if params[:tag]
        @posts = Post.where("published=TRUE").order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page)
      else
        @posts = Post.where("published=TRUE").order("created_at DESC").page(params[:page]).per_page(cards_per_page)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.js
    end
  end

  def show
    @post = Post.find(params[:id])
    impressionist(@post, "", :unique => [:session_hash])
    
    @pictureable = @post
    @pictures = @pictureable.pictures
    @picture = Picture.new

    #if (cannot? :author, @post) || (cannot? :manage, Post)
    if !(user_signed_in? && current_user.can_update?(@post))
      @post.increment_view_count 
    end

		@commentable = @post
  	@comments = @commentable.root_comments.order("created_at ASC")
		
		if user_signed_in?
			@comment = Comment.build_from(@commentable, current_user.id, "") 
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
        @post.create_activity :create, owner: @post.author if @post.published? && PublicActivity::Activity.where(owner_id: @post.author.id, owner_type: "User", trackable_id: @post.id, trackable_type: "Post").nil?
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
end