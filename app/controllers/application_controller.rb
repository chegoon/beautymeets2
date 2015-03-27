class ApplicationController < ActionController::Base
	protect_from_forgery

	# redirect to previous page when signup/login
	after_filter :store_location
	before_filter :save_referer
	before_filter :increment_page_view_count

	#include SimpleCaptcha::ControllerHelpers
	#before_filter :detect_browser

	#private
	#MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]

=begin
	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		MOBILE_BROWSERS.each do |m|
			if agent.match(m) && (agent == "android")
				puts "android detected" 
			else
				puts "android not detected"
			end

		end
	end
=end
	protected
	def increment_page_view_count
		puts "increment_page_view_count called"
		session[:page_view_count] ||= 0
		if (session[:page_view_count] > 4 && !user_signed_in?) && (controller_name != "sessions") && (controller_name != "registrations") && (controller_name != "authentications") && (controller_name != "passwords") && (controller_name != "infos") 
			#flash.now[:alert] = 'You need to login for forward'
			@isGuest = true
		else
			session[:page_view_count] = session[:page_view_count] + 1
			@isGuest = false
		end
	end

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
