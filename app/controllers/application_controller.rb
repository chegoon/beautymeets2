class ApplicationController < ActionController::Base
	protect_from_forgery

	# redirect to previous page when signup/login
	after_filter :store_location
	before_filter :save_referer
	
	#include SimpleCaptcha::ControllerHelpers

	def save_referer
		#puts "before_save, sessoin_referer : #{session['referer']}"
		unless user_signed_in? 
			unless session['referer'] 
				session['referer'] = request.env["HTTP_REFERER"] || 'none'
			end
		end
	
		#session['referer'] = request.env["HTTP_REFERER"] || 'none' until session['referer'] && user_signed_in?
		#puts "after_save, sessoin_referer : #{session['referer']}"
	end
	
	def store_location
		# store last url - this is needed for post-login redirect to whatever the user last visited.
		if (request.fullpath != "/users/login" &&
				request.fullpath != "/users/join" &&
				request.fullpath != "/users/password" &&
				request.fullpath != "/users/logout" &&
				!request.xhr?) # don't store ajax calls
			session[:previous_url] = request.fullpath 
		end
	end

	def after_sign_in_path_for(resource)
		session[:previous_url] || root_path
	end

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
