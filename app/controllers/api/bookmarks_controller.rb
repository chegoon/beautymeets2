module API
	class BookmarksController < API::BaseController
		#before_filter :load_bookmarkable
		before_filter :set_current_user, except: :index

		def index 
			bookmark_type_id = BookmarkType.find_or_create_by_model(params[:postType].downcase).id
			model_id = params[:postId]

			@bookmarks = Bookmark.where(model_type_id: bookmark_type_id,model_id: model_id)
			render json: @bookmarks
		end

		#toggle action
		def create
			bookmark_type_id = BookmarkType.find_or_create_by_model(params[:postType]).id
			model_id = params[:postId]
			
			@bookmark = Bookmark.find_bookmark(@user.id,bookmark_type_id,model_id)
			
			# We use a delete_all here because there is no other way in Rails to delete a row from a table without a PRIMARY KEY id
			if ( @bookmark )
				Bookmark.delete_all(["user_id = ? AND model_type_id = ? AND model_id = ?", @user.id, bookmark_type_id, model_id])
			else
				bookmark = Bookmark.create( :user_id => @user.id, :model_type_id => bookmark_type_id, :model_id => model_id)
				impressionist(bookmark)
			end
			
			render :status => 200, :json => { :success => true, :info => "bookmark successfully toggled"}
		end

		def show
			@bookmark = Bookmark.find(params[:id])
			render json: @bookmark
		end

		private

		def set_current_user
			token = params[:authToken] 
			@user = User.find_by_authentication_token(token)
		end
	end
end