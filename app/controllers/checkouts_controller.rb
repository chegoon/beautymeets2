class CheckoutsController < InheritedResources::Base
	before_filter :authenticate_user!


  def resource_name
    :user
  end

  def resource
    current_user || User.new
    #@resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class 
    User 
  end

  helper_method :resource_name, :resource, :devise_mapping, :resource_class


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
