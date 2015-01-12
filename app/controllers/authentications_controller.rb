# encoding: utf-8
class AuthenticationsController < ApplicationController
	# GET /authentications
	# GET /authentications.json

	before_filter :default_format_check, only: [:create]
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :cors_preflight_check, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_access_control_headers,  :if => Proc.new { |c| c.request.format == 'application/json' } 
	after_filter :set_csrf_cookie_for_ng,  :if => Proc.new { |c| c.request.format == 'application/json' } 
	
	before_filter :load_user_through_auth_token, :if => Proc.new { |c| c.request.format == 'application/json' } 
	
	def default_format_check
		if (session[:request_format].present? && session[:request_format] == "json")
			request.format = "json"
		end
	end

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

	def index
		@authentications = @user.authentications if @user

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @authentications }
		end
	end

	def create

		omniauth = request.env["omniauth.auth"]
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
		
		if authentication
			puts "welcome back, auth"
			flash[:notice] = "Signed in successfully."
			authentication.update_attributes(oauth_token: omniauth['credentials']['token'], oauth_token_secret: omniauth['credentials']['secret'])

			@auth = authentication
			
			respond_to do |format|
				#if (session[:request_format].present? && session[:request_format] == "json")
					format.json { redirect_to authentication_path(id: authentication.id, format: :json,  request_format: "json", authentication_token: params[:authToken])}
				#else 
					format.html { sign_in_and_redirect(:user, authentication.user) }
				#end
				#format.json { redirect_to "authentications/" + authentication.id + "?request_format='json'&authentication_token=" + params[:authToken] }
				#format.json { render json: {status: 200, success: true} }
			end	
			
		# user logged in previously, and trying to login with new authentication
		# guide user to select among login authentications"
		elsif (current_user || @user)
			puts "welcome back, from others existed auth"
			oauth_token = omniauth['credentials']['token']
 			oauth_token_secret = omniauth['credentials']['secret']
 
			if current_user 
				@auth = current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret)
			else
				@auth = @user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret)
			end	

			flash[:notice] = "Authentication successful."
			puts flash[:notice]
			
			respond_to do |format|
				#if (session[:request_format].present? && session[:request_format] == "json")
					format.json {render json: {status: 200, success: true, info: "Successfully Login", params: {user_id: @user.id, user_name: @user.name, :get_push_notifications => @user.get_push_notifications, authToken: @user.authentication_token }}}
				#else
					format.html {redirect_to root_url}
				#end
			end

		# brand new user
		else
			puts "welcome brand new auth"
			user = User.new
			# in case of facebook authentication, the below code might be needed
 			# user.email = omniauth['extra']['raw_info'].email
			user.apply_omniauth(omniauth)
			puts "brand new user"
			if user.save
	      		UserMailer.delay.welcome(user).deliver
	      		user.profile = Member.create!
	      		user.add_role :member
				user.save

				flash[:notice] = "Signed in successfully."

				# user_steps redirect
				sign_in(:user, user)
				respond_to do |format|
					#sign_in_and_redirect(:user, user)
					format.html {redirect_to user_steps_url} #user_step에서 json format 처리
				end
			else
				# save omniauth data in session for redirection without data needed
				session[:omniauth] = omniauth.except('extra')

				respond_to do |format|
					format.html {redirect_to new_user_registration_url}	#registartion에서 json format처리
				end

			end
		end
	end

	# DELETE /authentications/1
	# DELETE /authentications/1.json
	def destroy
		@authentication = @user.authentications.find(params[:id])
		@authentication.destroy
		flash[:notice] = "Successfully destroyed authentication."
		redirect_to authentications_url
	end

	def new
		@provider = params[:provider]
		@authentication = Authentication.new
		session[:request_format] = params[:request_format] #request.format

		respond_to do |format|
			format.html { redirect_to '/users/auth/'+ @provider }
			format.json  { redirect_to '/users/auth/'+ @provider  }
		end
	end

	def show
		#@authentication = Authentication.find_by_oauth_token(params[:id])
		@authentication = Authentication.find(params[:id])
	end

	protected
	def load_user_through_auth_token
		@user = current_user ? current_user : User.find_for_database_authentication(authentication_token: params[:authToken])
		#@user = User.find_by_authenticating_token(params[:auth_token])
	end
end
