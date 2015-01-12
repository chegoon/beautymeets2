class SessionsController < Devise::SessionsController
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| (c.request.format == 'application/json')  }
	#before_filter :cors_preflight_check, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_access_control_headers, :if => Proc.new { |c| c.request.format == 'application/json' }
	after_filter :set_csrf_cookie_for_ng, :if => Proc.new { |c| c.request.format == 'application/json' }
	before_filter :default_format_check
	prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel]

	def default_format_check
		#if (session[:request_format].present? && session[:request_format] == "json")
		if (params[:request_format].present? && params[:request_format] == "json")
			#request.format = "json"
			session[:request_format] = params[:request_format]
		end
	end

	# This is used to allow the cross origin POST requests made by app.
	def set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
		headers['Access-Control-Request-Method'] = '*'
		headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
		headers['Access-Control-Max-Age'] = "1728000"
		puts "set_access_control_headers done"
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
		puts "cors_preflight_check done"
	end

	def set_csrf_cookie_for_ng
		cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
	end

	def create

		puts "session create start"
		puts "request_format : #{request.format}"
		if (session[:request_format].present? && session[:request_format] == "json")
			puts "authenticate start for json"
			if warden.authenticate(:scope => resource_name, :recall => "#{controller_path}#failure")
			else
 				return invalid_login_attempt
			end
		else
			puts "authenticate start for not json"
			self.resource = warden.authenticate!(auth_options)
			set_flash_message(:notice, :signed_in) if is_flashing_format?
			sign_in(resource_name, resource)
		end

		puts "authenticate done"
		username = current_user.name ? current_user.name : current_user.email
		yield resource if block_given?
		respond_to do |format|
			#if (session[:request_format].present? && session[:request_format] == "json")
				format.json  {

					device = current_user.devices.find_or_create_by_uuid(params[:device][:uuid])
					device.platform_type = params[:device][:platform_type]
					device.platform_version = params[:device][:platform_version]
					device.name = params[:device][:name]
					device.save!

					render json: {:status => 200, :success => true, :info => "Logged in", :params => {:user_id => current_user.id, :user_name => username, :get_push_notifications => current_user.get_push_notifications,  :authToken => current_user.authentication_token }}
				}
			#else
				format.html {respond_with resource, location: after_sign_in_path_for(resource)}
			#end
			
		end
	end

	# forward new action if any exception occurs in sesion create
	def new
		if (session[:request_format].present? && session[:request_format] == "json")

		else
			self.resource = resource_class.new(sign_in_params)
	    	clean_up_passwords(resource)
		end

		yield resource if block_given?	
		respond_to do |format|
			format.json  {

				render json: {:status => 200, :success => true, :info => "Logged in"}
			}
			format.html {respond_with resource, location: serialize_options(resource)}
		end
		#respond_with(resource, serialize_options(resource))
	end
		
	def destroy
		puts "destroy called"
	    

	    respond_to do |format|
			#if (session[:request_format] != nil? && session[:request_format] == "json")
			if (request.format == "json")
				puts "json destroy #{session[:request_format]}"
				
				token = params[:authToken]
				user = User.find_by_authentication_token(token)
				if user
					user.update_column(:authentication_token, nil)
					#user.reset_authentication_token!
					#warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
					format.json { render :status => 200, :json => { :success => true, :info => "Logged out", :params => {} }}
				else
					format.json {render :json => { :message => 'Invalid token.' }, :status => 404}
				end 

			else
				signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
	    		set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
	    		yield if block_given?
				
				format.html { respond_to_on_destroy }
			end
		end

	end
	 
	def failure
		respond_to do |format|
			format.html {
				super
			}
			format.json {render :status => 401, :json => { :success => false, :info => "Login Failed", :data => {} }
			}
		end
	end

	def show_current_user
		warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
		render :status => 200, :json => { :success => true, :info => "Current User", :user => current_user }
	end

	def invalid_login_attempt
    	warden.custom_failure!
		render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
	end

	protected
	def verified_request?
		super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
	end
end