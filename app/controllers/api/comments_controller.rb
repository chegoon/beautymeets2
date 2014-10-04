module API
	class CommentsController < API::BaseController
		before_filter :load_commentable
		before_filter :set_current_user, except: [:index, :show]  
		#before_filter :authenticate_user, except: [:index, :show]  
		#authorize_actions_for Comment, except: [:index, :show, :vote, :unvote]

		def index
			comments_per_page = 10
			#@comments = @commentable.comments.where("parent_id IS NULL").order("created_at ASC").page(params[:page]).per_page(comments_per_page)
			@comments = @commentable.comments
			#render json: @comments
		end

		def new
			@comment = @commentable.comments.new
		end

		def show
			@comment = Comment.find(params[:id])
			render json: @comment
		end

		def create
			puts "param : #{params[:comment][:body]}"
			@comment = Comment.build_from(@commentable, @user.id, params[:comment][:body])

			if @comment.save
				puts "comment : #{@comment}"
=begin
				if params[:comment][:parent_id]
					@parent = Comment.find(params[:comment][:parent_id]) 
					if !(@commentable.class.name == "Event")
						CommentMailer.delay.parent_notification(@parent, @commentable, @comment) unless @parent.invalid?
					end
				end

				if !(@commentable.class.name == "Event")
					CommentMailer.delay.create_notification(@commentable, @comment)
				end
				#@comment.create_activity :create, owner: @user, recipient: @commentable.author
			
				if @parent
					@comment.move_to_child_of(@parent)
					@comment.create_activity :create, owner: @user, recipient: @parent.author if !(@commentable.class.name == "Notice")
				else
					@comment.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
				end
=end
				render :status => 200, :json => { :success => true, :info => "Successfully comment created"}
			
			else
				render :status => 200, :json => { :success => true, :info => "Something wrong.."}
			
				#render :new
			end
		end

		def destroy
			@comment = @commentable.comments.find(params[:id])

			@comment.destroy

			respond_to do |format|
				format.html { redirect_to @commentable, notice: "Comment destroied"  }
				format.js
				format.json { head :no_content }
			end
		end

		def vote
			@comment = @commentable.comments.find(params[:id])
			authorize_action_for @comment

			@comment.liked_by @user

			respond_to do |format|
				format.html { redirect_to @commentable, notice: "Comment voted"  }
				format.js
				format.json { head :no_content }
			end
		end

		def unvote
			@comment = @commentable.comments.find(params[:id])
			authorize_action_for @comment
			
			@comment.unliked_by @user
			respond_to do |format|
				format.html { redirect_to @commentable, notice: "Comment unvoted"  }
				format.js
				format.json { head :no_content }
			end
		end

		private

		def load_commentable
			id = request.path.split('/')[3]
			resource = params[:postType] 
			@commentable = (resource.singularize + "s").classify.constantize.find(id)
		end

		def set_current_user
			token = params[:authToken] 
			@user = User.find_by_authentication_token(token)
		end
	end
end