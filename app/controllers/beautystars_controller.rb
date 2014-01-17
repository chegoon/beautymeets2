class BeautystarsController < InheritedResources::Base
	before_filter :authenticate_user!, except: [:index, :show]  

	
	def show
		@beautystar = Beautystar.find(params[:id])

	  @pictureable = @beautystar
	  @pictures = @pictureable.pictures
	  @picture = Picture.new

	  @tutorials = @beautystar.user.tutorials
	end

	def create
		@beautystar = current_user.profile.create(params[:beautystar])
    current_user.add_role :author, @beautystar
	end

	def update
		super
    @beautystar.create_activity :update, owner: @beautystar.user
	end
end
