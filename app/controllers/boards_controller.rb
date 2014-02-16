class BoardsController < InheritedResources::Base
	# Load authorizing from cancan
  #load_and_authorize_resource
  # authorize controller thourgh authority
  authorize_actions_for Board, except: [:index, :show]

  respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  

  autocomplete :item, :name
  
  # GET /boards
  # GET /boards.json
  def index
    cards_per_page = 12

    if (params[:order].present?) && (params[:order] == "popular")
      if params[:tag]
        @boards = Board.where("published=TRUE").order("view_count DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page)
      else
        @boards = Board.where("published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
      end
    else      
      if params[:tag]
        @boards = Board.where("published=TRUE").order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page)
      else
        @boards = Board.where("published=TRUE").order("created_at DESC").page(params[:page]).per_page(cards_per_page)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boards }
      format.js
    end
  end

  def show
    @board = Board.find(params[:id])

    @pictureable = @board
    @pictures = @pictureable.pictures
    @picture = Picture.new

    #if (cannot? :author, @board) || (cannot? :manage, Board)
    if user_signed_in? && !current_user.can_update?(@board)
      @board.increment_view_count 
    end

		@commentable = @board
  	@comments = @commentable.root_comments.order("created_at ASC")
		
		if user_signed_in?
			@comment = Comment.build_from(@commentable, current_user.id, "") 
      @board.mark_as_read! :for => current_user
		else
			@comment = Comment.new
		end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @board }
    end
  end

  # POST /boards
	# POST /boards.json
	def create
		@board = current_user.boards.create(params[:board])
    current_user.add_role :author, @board
		#@board = Beautorial.new(params[:board])

		respond_to do |format|
			if @board.save
				format.html { redirect_to @board, notice: 'Board was successfully created.' }
				format.json { render json: @board, status: :created, location: @board }
			else
				format.html { render action: "new" }
				format.json { render json: @board.errors, status: :unprocessable_entity }
			end
		end
	end

  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        @board.create_activity :create, owner: @board.author if @board.published? && PublicActivity::Activity.where(owner_id: @board.author.id, owner_type: "User", trackable_id: @board.id, trackable_type: "Board").nil?
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end
end
