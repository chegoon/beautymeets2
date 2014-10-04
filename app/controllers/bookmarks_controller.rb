class BookmarksController < InheritedResources::Base
	def show
		@user = User.find(params[:user_id])
		@bookmarks = Bookmark.find_all_by_user_id(params[:user_id]).paginate(:page => params[:page], :per_page => 10)
	end

	def toggle
		uri_array = CGI::unescape(params[:url]).split(%r{/})
		puts "request.path #{request.path}"
		bookmark_type_id = BookmarkType.find_or_create_by_model(uri_array[1].singularize).id
		modeltype = BookmarkType.find_or_create_by_model(uri_array[1].singularize).model.capitalize.constantize 
		model_id = modeltype.find_id_by_site_url(params[:url])
		
		@bookmark = Bookmark.find_bookmark(current_user.id,bookmark_type_id,model_id)
		
		# We use a delete_all here because there is no other way in Rails to delete a row from a table without a PRIMARY KEY id
		if ( @bookmark )
			Bookmark.delete_all(["user_id = ? AND model_type_id = ? AND model_id = ?", current_user.id, bookmark_type_id, model_id])
		else
			bookmark = Bookmark.create( :user_id => current_user.id, :model_type_id => bookmark_type_id, :model_id => model_id)
			impressionist(bookmark)
		end
		
		respond_to do |format|
			format.html
			format.js { render :layout => false }
		end
		
	end
end
