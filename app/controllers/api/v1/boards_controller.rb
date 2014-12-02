module API
	module V1
		class BoardsController < API::BaseController
			#authorize_actions_for Board, except: [:index, :show]

			#before_filter :authenticate_user!, except: [:index, :show]  
			before_filter :set_current_user
			
			# GET /boards
			# GET /boards.json
			def index

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				@boards = Board.order("created_at DESC").offset(offset).limit(limit)

				respond_to do |format|
					#format.html # index.html.erb
					format.json 
				end
			end

			def show
				@board = Board.find(params[:id])

				#if (cannot? :author, @board) || (cannot? :manage, Board)
				if user_signed_in? && !current_user.can_update?(@board)
					@board.increment_view_count 
				end

				@commentable = @board
				comments_per_page = 7
				page_index = params[:page] ? params[:page] : @commentable.comment_threads.order("lft ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
				#@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)
				@comments = @commentable.comment_threads.order("lft ASC")#.page(page_index).per_page(comments_per_page)

				respond_to do |format|
					#format.html # show.html.erb
					format.json 
				end
			end

			# POST /boards
			# POST /boards.json
			def create
				if params[:image]
					board_params = JSON.parse(params[:board])
					@board = @user.boards.new({user_id: @user.id, title: board_params['title'],  description: board_params['description'], picture_attributes: {image: params[:image]}}) 
				else
					@board = @user.boards.create({title: params[:board][:title], description: params[:board][:description]})	
				end

				respond_to do |format|
					if @board.save
						@user.add_role :author, @board
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

			private

			def set_current_user
				token = params[:authToken] 
				@user = User.find_by_authentication_token(token)
			end
		end
	end
end
