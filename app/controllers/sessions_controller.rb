class SessionsController < Devise::SessionsController
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


	def create
		respond_to do |format|
			format.html {
				super
			}
			format.json {
				#puts "params : #{params}"
				warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
				#puts "current_user token: #{current_user.authentication_token}"
				#sign_in(resource_name, resource)
				render :status => 200, :json => { :success => true, :info => "Logged in", :params => {:user_id => current_user.id, :user_name => current_user.name,  :authToken => current_user.authentication_token } }
			}
		end
	end
		
	def destroy
		respond_to do |format|
			format.html {
				super
			}
			format.json {
				token = params[:authToken]
				user = User.find_by_authentication_token(token)
				if user
					user.update_column(:authentication_token, nil)
					#user.reset_authentication_token!
					#warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
					render :status => 200, :json => { :success => true, :info => "Logged out", :params => {} }
				else
					render :json => { :message => 'Invalid token.' }, :status => 404
				end 
			}
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

	protected
	def verified_request?
		super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
	end
end