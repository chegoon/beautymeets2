# encoding: utf-8
class AuthenticationsController < ApplicationController
	# GET /authentications
	# GET /authentications.json

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :cors_preflight_check, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_access_control_headers,  :if => Proc.new { |c| c.request.format == 'application/json' } 
	after_filter :set_csrf_cookie_for_ng,  :if => Proc.new { |c| c.request.format == 'application/json' } 
	before_filter :load_user_through_auth_token, :if => Proc.new { |c| c.request.format == 'application/json' } 
	before_filter :default_format_json

	def default_format_json
		if (params[:request_format] && params[:request_format] == "json") || (session[:request_format].present? && session[:request_format] == "json") # || (request.headers["HTTP_ACCEPT"].nil? && params[:format].nil?) || 
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
			flash[:notice] = "Signed in successfully."
			authentication.update_attributes(oauth_token: omniauth['credentials']['token'], oauth_token_secret: omniauth['credentials']['secret'])
			

			if session[:request_format] == "json"
				@auth = authentication
				session[:request_format] = nil
				respond_to do |format|
					#format.html {render :status => 200, :content_type => 'application/json', :json => { :success => true, :info => "Logged in", :params => {:user_id => authentication.user.id, :user_name => authentication.user.name,  :authToken => authentication.user.authentication_token }}}
					format.json { redirect_to authentication_path(id: authentication.id, request_format: "json") }
						#render :status => 200, :success => true, :info => "Logged in", :params => {:user_id => authentication.user.id, :user_name => authentication.user.name,  :authToken => authentication.user.authentication_token }
				end
				
			else
				respond_to do |format|
					format.html { sign_in_and_redirect(:user, authentication.user) }
				end
			end	
			
		# user logged in previously, and trying to login with new authentication
		# guide user to select among login authentications"
		elsif (current_user || @user)

			oauth_token = omniauth['credentials']['token']
 			oauth_token_secret = omniauth['credentials']['secret']
 
			if current_user 
				current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret)
			else
				@user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret)
			end	

			flash[:notice] = "Authentication successful."
			puts flash[:notice]

			if session[:request_format] == "json"
				@auth = current_user ? current_user.authentication : @user.authentication
				session[:request_format] = nil
				respond_to do |format|
					#format.html {render :text => {:status => 200, :json => { :success => true, :info => "Successfully Login", :params => {:user_id => @user.id, :user_name => @user.name,  :authToken => @user.authentication_token }}}}
					format.json #{render :status => 200, :json => { :success => true, :info => "Successfully Login", :params => {:user_id => @user.id, :user_name => @user.name,  :authToken => @user.authentication_token }}}
				end
				
			else
				respond_to do |format|
					format.html {redirect_to root_url}
				end
			end

		# brand new user
		else
			user = User.new
			# in case of facebook authentication, the below code might be needed
 			# user.email = omniauth['extra']['raw_info'].email
			user.apply_omniauth(omniauth)
			puts "brand new user"
			if user.save
	      		UserMailer.welcome(user).deliver
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
			format.json  { redirect_to '/users/auth/'+ @provider + '?format=json' }
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
