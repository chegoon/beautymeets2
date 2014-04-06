class ApplicationController < ActionController::Base
  protect_from_forgery

  include SimpleCaptcha::ControllerHelpers
  
  
  # public_activity gem의 tracked method를 model에서 사용할때 controller.current_user메소드를 사용하려면
  # 모델에서 current_user접근이 이루어져야하는데 이는 private 메소드이기에 application_controller에서 public으로 선언해주고 
  # 대신 hide_action 지정
=begin  
	include PublicActivity::StoreController
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  hide_action :current_user
=end

  # devise controller들을 render partial할 경우 resource method가 devise controller들을 거쳐 호츌되지 않아서 오류발생
  def resource_name 
    :user 
  end 

  def resource 
    @resource ||= User.new 
  end 

  def devise_mapping 
    @devise_mapping ||= Devise.mappings[:user] 
  end 

  def resource_class 
    User 
  end

  helper_method :resource_name, :resource, :devise_mapping, :resource_class

end
