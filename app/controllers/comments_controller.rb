
class CommentsController < ApplicationController
	before_filter :load_commentable
	before_filter :authenticate_user!, except: [:index, :show]  
	authorize_actions_for Comment, except: [:index, :show, :vote, :unvote]

	def index
		comments_per_page = 10
		@comments = @commentable.comments.where("parent_id IS NULL").order("created_at ASC").page(params[:page]).per_page(comments_per_page)
		@comment.child.build
	end

	def new
		@comment = @commentable.comments.new
	end

	def create
		@comment = Comment.build_from(@commentable, current_user.id, params[:comment][:body])
		
		if @comment.save

			if params[:comment][:parent_id]
				@parent = Comment.find(params[:comment][:parent_id]) 
				if !(@commentable.class.name == "Event")
					CommentMailer.delay.parent_notification(@parent, @commentable, @comment) unless @parent.invalid?
				end
			end

			if !(@commentable.class.name == "Event")
				CommentMailer.delay.create_notification(@commentable, @comment)
			end
			#@comment.create_activity :create, owner: current_user, recipient: @commentable.author
		
			if @parent
				@comment.move_to_child_of(@parent)
				@comment.create_activity :create, owner: current_user, recipient: @parent.author if !(@commentable.class.name == "Notice")
			else
				@comment.create_activity :create, owner: current_user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
			end

			if !(@commentable.class.name == "Notice")
				respond_to do |format|
					format.html { redirect_to @commentable, notice: "Comment created." }
					format.js 
				end
			else
				respond_to do |format|
					format.html { redirect_to "/notices?makeup_request=true", notice: "Comment created." }
					format.js 
				end
			end
		else
			render :new
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
		@comment = @commentable.comments.find(params[:comment_id])
		authorize_action_for @comment

		@comment.liked_by current_user

		respond_to do |format|
			format.html { redirect_to @commentable, notice: "Comment voted"  }
			format.js
			format.json { head :no_content }
		end
	end

	def unvote
		@comment = @commentable.comments.find(params[:comment_id])
		authorize_action_for @comment
		
		@comment.unliked_by current_user
		respond_to do |format|
			format.html { redirect_to @commentable, notice: "Comment unvoted"  }
			format.js
			format.json { head :no_content }
		end
	end

	private

	def load_commentable
		resource, id = request.path.split('/')[1,2]
		@commentable = (resource.singularize + "s").classify.constantize.find(id)
	end

end