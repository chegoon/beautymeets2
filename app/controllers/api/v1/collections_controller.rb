#encoding: utf-8
module API
	module V1
		class CollectionsController < API::V1::BaseController
			inherit_resources

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
		end
	end
end