class BeautystarsController < InheritedResources::Base
	before_filter :authenticate_user!, except: [:index, :show]  

	
	def show
		@beautystar = Beautystar.find(params[:id])

	  @pictureable = @beautystar
	  @pictures = @pictureable.pictures
	  @picture = Picture.new

	  @tutorials = @beautystar.user.tutorials.last(6)
	  @beautyclasses = @beautystar.user.beautyclasses.last(4)
	end

	def create
		@beautystar = current_user.profile.create(params[:beautystar])
		@beautystar.create_activity :create, owner: @beautystar.user
    current_user.add_role :author, @beautystar
	end
end
