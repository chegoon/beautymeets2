#encoding: utf-8
module API
	module V1
		class CollectionsController < API::V1::BaseController
			inherit_resources
			before_filter :set_current_user

			def index
				menu = Category.where(name: params[:category], parent_id: Category.find_by_name("menu").id).first
				categories = menu ? Category.where(menu_id: menu.id) : nil
				
				if categories
					@collections = Collection.joins(:categories).where("collections.published is TRUE AND categories.id IN (?)", categories.map(&:id)).order("created_at DESC")
				else
					@collections = Collection.where(published: true).order("created_at DESC")
				end
					
			end
			def show
				@collection = Collection.find(params[:id])

				@pictureable = @collection
				@pictures = @pictureable.pictures
				@picture = Picture.new

				respond_to do |format|
					format.html # show.html.erb
					format.json { render json: @collection }
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