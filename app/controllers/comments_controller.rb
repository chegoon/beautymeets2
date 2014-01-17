
class CommentsController < ApplicationController
	before_filter :load_commentable
	before_filter :authenticate_user!, except: [:index, :show]  

  def index
  	#@commentable = Products.find(params[:product_id])
  	@comments = @commentable.comments.where("parent_id IS NULL").order("created_at ASC")
    @comment.child.build
  end

  def new
  	@comment = @commentable.comments.new

  end
=begin
  def add_child
    @comment = Comment.build_from( @commentable, current_user.id, params[:comment][:body])
    @comment.move_to_child_of(the_desired_parent_comment)
    redirect_to @commentable, notice: "Comment created."
  end 
=end

  def create
  	#@comment = @commentable.comments.new(params[:comment])
    @comment = Comment.build_from( @commentable, current_user.id, params[:comment][:body])

    if params[:comment][:parent_id]
      @parent = Comment.find(params[:comment][:parent_id]) 
    end

  #	@comment.user_id = current_user.id

  	if @comment.save     

      @comment.create_activity :create, owner: current_user
      
      if @parent
        @comment.move_to_child_of(@parent)
      end
      #@comment.create_activity :create, owner: current_user, recipient: @commentable.user
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
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end