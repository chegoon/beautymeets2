class RegistrationsController < Devise::RegistrationsController

	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :cors_preflight_check, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_access_control_headers, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_csrf_cookie_for_ng, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :default_format_check

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


	def create
		build_resource(sign_up_params)
		session[:omniauth] = nil unless @user.new_record? 
		resource_saved = resource.save

		if resource_saved
		 
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
				respond_to do |format|
					# respond_with resource, :location => after_sign_up_path_for(resource)
					format.html { redirect_to after_sign_up_path_for(resource) }
					format.json { render json: {status: 200, success: true, info: "Successfully joined", params: {user_id: current_user.id, user_name: current_user.name,  authToken: current_user.authentication_token }}}
				end

			else
				set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
				expire_data_after_sign_in!
				
				# user_steps redirect
				respond_to do |format|
					# respond_with resource, :location => after_inactive_sign_up_path_for(resource)
					format.html { redirect_to after_inactive_sign_up_path_for(resource) }
					format.json { render json: {status: 401, success: false, info: "Something wrong in join" }}
				end

			end
			
		else
			clean_up_passwords resource
			#respond_with resource

			respond_to do |format|
				format.html { respond_with resource }
				#format.html { redirect_to new_user_registration_path }
				format.json { render json: {status: 401, success: false, info: "Something wrong in join" }}
			end

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
