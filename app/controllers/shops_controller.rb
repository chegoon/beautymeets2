class ShopsController < InheritedResources::Base
	before_filter :authenticate_user!, except: [:index, :show]  

	def show
		@shop = Shop.find(params[:id])
		@location = @shop.location

    respond_to do |format|
      format.html 
      format.json { render @shop }
    end

	end
end
