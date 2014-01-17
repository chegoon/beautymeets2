class LocationsController < InheritedResources::Base
	before_filter :authenticate_user!, except: [:index, :show]  
	respond_to :html, :json

	def create
		@shop = Shop.find(params[:shop_id])
		@create = @shop.location.create(params[:location])

		respond_to @shop
	end

	def show
		@location = Location.find(params[:id])

		@hash = Gmaps4rails.build_markers(@location) do |location, marker|
		  marker.lat location.latitude
		  marker.lng location.longitude		  
		end

		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
	end
end
