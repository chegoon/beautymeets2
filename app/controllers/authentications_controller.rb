# encoding: utf-8
class AuthenticationsController < ApplicationController
	# GET /authentications
	# GET /authentications.json

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :cors_preflight_check, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_access_control_headers,  :if => Proc.new { |c| c.request.format == 'application/json' } 
	after_filter :set_csrf_cookie_for_ng,  :if => Proc.new { |c| c.request.format == 'application/json' } 
	before_filter :load_user_through_auth_token, :only => [:index, :create, :destroy]

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


	# POST /authentications
	# POST /authentications.json
	def create

		omniauth = request.env["omniauth.auth"]
		puts "omniauth : #{omniauth}"
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
		puts "authentication : #{authentication}"

		respond_to do |format|
			format.html {

				if authentication
					flash[:notice] = "Signed in successfully."
					authentication.update_attributes(oauth_token: omniauth['credentials']['token'], oauth_token_secret: omniauth['credentials']['secret'])
					sign_in_and_redirect(:user, authentication.user)
					
				# user logged in previously, and trying to login with new authentication
				# guide user to select among login authentications"
				elsif current_user
					puts "user logged in previously, and trying to login with new authentication"

					oauth_token = omniauth['credentials']['token']
		 			oauth_token_secret = omniauth['credentials']['secret']
		 
					current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret)
					flash[:notice] = "Authentication successful."
					redirect_to welcome_url

				# brand new user
				else
					puts "brand new user"
					user = User.new
					# in case of facebook authentication, the below code might be needed
		 			# user.email = omniauth['extra']['raw_info'].email
					user.apply_omniauth(omniauth)

					if user.save
			      		#UserMailer.welcome(user).deliver
			      		user.profile = Member.create!
			      		user.add_role :member
						user.save

						flash[:notice] = "Signed in successfully."

						# user_steps redirect
						sign_in(:user, user)
						redirect_to user_steps_url
						#sign_in_and_redirect(:user, user)
					else
						session[:omniauth] = omniauth.except('extra')
						redirect_to new_user_registration_url
					end
				end
			}
			format.json {

				if authentication
					puts "exited authentication is generated"
					authentication.update_attributes(oauth_token: omniauth['credentials']['token'], oauth_token_secret: omniauth['credentials']['secret'])
					@user = authentication.user
					#sign_in_and_redirect(:user, authentication.user) action in HTML
					sign_in(resource_name, resource)
					#warden.authenticate!(:scope => "user", :recall => "#{controller_path}#failure")
					render :status => 200, :json => { :success => true, :info => "Logged in", :params => {:user_id => @user.id, :user_name => @user.name,  :authToken => @user.authentication_token } }
			
				elsif @user
					puts "new authentication of existed user is created"
					oauth_token = omniauth['credentials']['token']
		 			oauth_token_secret = omniauth['credentials']['secret']
		 
					@user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret)
					flash[:notice] = "Authentication successful."
					
					#redirect_to welcome_url action in HTML
					render :status => 200, :json => { :success => true, :info => "Successfully Login", :params => {:user_id => @user.id, :user_name => @user.name,  :authToken => @user.authentication_token } }
				
				# brand new user
				else
					puts "brand new user"
					user = User.new
					user.apply_omniauth(omniauth)

					if user.save
			      		user.profile = Member.create!
			      		user.add_role :member
						user.save

						flash[:notice] = "Signed in successfully."

						sign_in(:user, user)

						#redirect_to user_steps_url
						render :status => 200, :json => { :success => true, :info => "Successfully joined", :params => {:user_id => user.id, :user_name => user.name,  :authToken => user.authentication_token } }
					else
						session[:omniauth] = omniauth.except('extra')
						#redirect_to new_user_registration_url
						render :status => 401, :json => { :success => true, :info => "Somthing wrong your authetication"}
					end
				end
			}
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


	protected
	def load_user_through_auth_token
		@user = User.find_for_database_authentication(authentication_token: params[:authToken])
		#@user = User.find_by_authenticating_token(params[:auth_token])
	end
end
