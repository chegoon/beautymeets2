class RegistrationsController < Devise::RegistrationsController
 #before_filter :set_account

	def create
		
		build_resource(sign_up_params)
		session[:omniauth] = nil unless @user.new_record? 
		
		
			if resource.save
			 
				resource.profile = Member.create!
				resource.add_role :member
				resource.came_from = session['referer']
				resource.joined_for = session[:previous_url]
				resource.save
				UserMailer.delay.welcome(resource) unless @user.invalid?

				yield resource if block_given?
				if resource.active_for_authentication?
					set_flash_message :notice, :signed_up if is_flashing_format?
					sign_up(resource_name, resource)
					# user_steps redirect
					respond_with resource, :location => after_sign_up_path_for(resource)
				else
					set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
					expire_data_after_sign_in!
					# user_steps redirect
					respond_with resource, :location => after_inactive_sign_up_path_for(resource)
				end
			else
				clean_up_passwords resource
				respond_with resource
			end
	end

	def update
		# For Rails 4
		#account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
		# For Rails 3
		account_update_params = params[:user]

		# required for settings form to submit when password is left blank
		if account_update_params[:password].blank?
			account_update_params.delete("password")
			account_update_params.delete("password_confirmation")
		end

		@user = User.find(current_user.id)
		if @user.update_attributes(account_update_params)
			set_flash_message :notice, :updated
			# Sign in the user bypassing validation in case his password changed
			sign_in @user, :bypass => true
			redirect_to after_update_path_for(@user)
		else
			render "edit"
		end
	end

	def edit
		@user = User.find(current_user.id)
		@member = @user.profile if @user.has_role? :member
		@beautystar = @user.profile if @user.has_role? :beautystar
		super
	end

	private
	def after_sign_up_path_for(resource)
		user_steps_path
	end

	private
	def after_inactive_sign_up_path_for(resource)
		user_steps_path
	end

	private
	def build_resource(*args)
		super
		if session[:omniauth]
			@user.apply_omniauth(session[:omniauth])
			@user.valid?
		end
	end

	private
	# check if we need password to update user data
	# ie if password or email was changed
	# extend this as needed
	def needs_password?(user, params)
		user.email != params[:user][:email] ||
		params[:user][:password].present?
	end

end
