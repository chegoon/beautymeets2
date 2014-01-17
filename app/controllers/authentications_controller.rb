# encoding: utf-8
class AuthenticationsController < InheritedResources::Base
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

		@email_verified  = omniauth.info["email"]
		@user_name_verified = omniauth.info["name"]
		@user_remote_image_url_verified = omniauth.info["image"]

		if authentication
			flash[:notice] = "Signed in successfully."
			sign_in_and_redirect(:user, authentication.user)
			
		elsif current_user
			puts "user logged previously, and trying to login with new authentication"
			puts "guide user to select among login authentications"
			current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :oauth_token => omniauth['credentials']['token'])
			flash[:notice] = "Authentication successful."
			redirect_to authentications_url

		else
			puts  "brand new user."
			user = User.new
			user.apply_omniauth(omniauth)

			if user.save
	      UserMailer.welcome(user).deliver
	      user.profile = Member.create!
	      user.add_role :member
				
				flash[:notice] = "Signed in successfully."
				sign_in_and_redirect(:user, user)
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
