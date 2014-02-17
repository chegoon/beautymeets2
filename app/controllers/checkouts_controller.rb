class CheckoutsController < ApplicationController
  inherit_resources
	before_filter :authenticate_user!


  def create
    @beautyclass = Beautyclass.find(params[:beautyclass_id])
    @checkout = @beautyclass.checkouts.create(params[:checkout])
    @checkout.user = current_user
    @checkout.user.save
    @checkout.save

    UserMailer.beautyclass_request(@beautyclass, @checkout, @beautyclass.author, current_user).deliver

    redirect_to beautyclass_path(@beautyclass), notice: "Class request done"
  end
end
