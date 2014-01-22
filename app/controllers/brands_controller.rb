class BrandsController < InheritedResources::Base
	before_filter :authenticate_user!, except: [:index, :show]  
	
  def show
  	@brand = Brand.find(params[:id])
  	@tutorials = Tutorial.joins(:items).where("item_id IN (?)", Item.where(brand_id: @brand.id).map(&:id))
  	@items = @brand.items


    @pictureable = @brand
    @pictures = @pictureable.pictures
    @picture = Picture.new
    
    if cannot? :manage, @brand
      @brand.increment_view_count 
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brand }
    end
  end
end
