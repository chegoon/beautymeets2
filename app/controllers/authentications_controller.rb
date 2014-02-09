# encoding: utf-8
class AuthenticationsController < ApplicationController
	# GET /authentications
	# GET /authentications.json
	def index
		@authentications = current_user.authentications if current_user

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @authentications }
		end

	end


	# POST /authentications
	# POST /authentications.json
	def create

		omniauth = request.env["omniauth.auth"]
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
		
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
	end

	# DELETE /authentications/1
	# DELETE /authentications/1.json
	def destroy
		@authentication = current_user.authentications.find(params[:id])
		@authentication.destroy
		flash[:notice] = "Successfully destroyed authentication."
		redirect_to authentications_url
	end
end
