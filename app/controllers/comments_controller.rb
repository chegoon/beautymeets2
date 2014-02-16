
class CommentsController < ApplicationController
	before_filter :load_commentable
	before_filter :authenticate_user!, except: [:index, :show]  
  authorize_actions_for Comment, except: [:index, :show]

  def index
  	@comments = @commentable.comments.where("parent_id IS NULL").order("created_at ASC")
    @comment.child.build
  end

  def new
  	@comment = @commentable.comments.new

  end

  def create
    @comment = Comment.build_from(@commentable, current_user.id, params[:comment][:body])

    if params[:comment][:parent_id]
      @parent = Comment.find(params[:comment][:parent_id]) 
    end

  	if @comment.save     

      #@comment.create_activity :create, owner: current_user, recipient: @commentable.author
      
      if @parent
        @comment.move_to_child_of(@parent)
      end
  		redirect_to @commentable, notice: "Comment created."
  	else
  		render :new
  	end
  end

  def destroy
  	@comment = @commentable.comments.find(params[:id])

  	@comment.destroy

    respond_to do |format|
      format.html { redirect_to @commentable, notice: "Comment destroied"  }
      format.json { head :no_content }
    end
  end

	private

  def load_commentable
    resource, id = request.path.split('/')[1,2]
    @commentable = (resource.singularize + "s").classify.constantize.find(id)
  end

end