class BookmarksController < InheritedResources::Base

  def show
    @user = User.find(params[:user_id])
    
    @bookmark = @bookmarkable.bookmarks.where(user_id: @user.id).find(params[:id])
  end

  def toggle
    uri_array = CGI::unescape(params[:url]).split(%r{/})
    bookmark_type_id = Bookmarktype.find_by_model(uri_array[1].singularize).id
    modeltype = Bookmarktype.find_by_model(uri_array[1].singularize).model.capitalize.constantize
    model_id = modeltype.find_id_by_site_url(request_uri)
    
    @bookmark = Bookmark.find_bookmark(current_skydiver.id,bookmark_type_id,model_id)
    @bookmark = @bookmarkable.bookmarks.where(user_id: @user.id).find(params[:id])

    # We use a delete_all here because there is no other way in Rails to delete a row from a table without a PRIMARY KEY id
    if ( @bookmark )
      Bookmark.delete_all(["user_id = ? AND model_type_id = ? AND model_id = ?", current_user.id, bookmark_type_id, model_id])
    else
      Bookmark.create( :user_id => current_user.id, :model_type_id => bookmark_type_id, :model_id => model_id)
    end
    
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
    
  end


	private

  def load_bookmarkable
    resource, id = request.path.split('/')[1,2]
    #@commentable = resource.singularize.classify.constantize.find(id)
    @bookmarkable = (resource.singularize + "s").classify.constantize.find(id)
  end
end
