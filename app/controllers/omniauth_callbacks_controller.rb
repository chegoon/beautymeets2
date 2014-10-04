# encoding: utf-8
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :cors_preflight_check
	after_filter :set_access_control_headers,  :set_csrf_cookie_for_ng

	# This is used to allow the cross origin POST requests made by app.
	def set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
		headers['Access-Control-Request-Method'] = '*'
		headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
		headers['Access-Control-Max-Age'] = "1728000"
	end

	# If this is a preflight OPTIONS request, then short-circuit the
	# request, return only the necessary headers and return an empty
	# text/plain.

	def cors_preflight_check
		if request.method == :options
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
			headers['Access-Control-Request-Method'] = '*'
			headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
			headers['Access-Control-Max-Age'] = '1728000'
			render :text => '', :content_type => 'text/plain'
		end
	end

	def set_csrf_cookie_for_ng
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
	end

	def all
		#raise request.env["omniauth.auth"].to_yaml
		user = User.from_omniauth(request.env["omniauth.auth"])
		
		respond_to do |format|
			format.html {
				if user.persisted?
			      	flash.notice = "Signed in!"
			      	sign_in_and_redirect user
				else
					session["devise.user_attributes"] = user.attributes
					redirect_to new_user_registration_url
				end
			}
			format.json {
				if user.persisted?
			      	flash.notice = "Signed in!"
			      	sign_in_and_redirect user
				else
					session["devise.user_attributes"] = user.attributes
					redirect_to new_user_registration_url
				end
				
			}
		end
	end

	alias_method :facebook, :all
end
