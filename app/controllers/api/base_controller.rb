module API
	class BaseController < ApplicationController
		after_filter :set_access_control_headers, :set_csrf_cookie_for_ng
		before_filter :cors_preflight_check

		respond_to :json

		# This is used to allow the cross origin POST requests made by app.
		def set_access_control_headers
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
			headers['Access-Control-Request-Method'] = '*'
			headers['Access-Control-Allow-Headers'] = 'Origin, x-xsrf-token, X-Requested-With, Content-Type, Accept, Authorization'
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
				headers['Access-Control-Allow-Headers'] = 'Origin, x-xsrf-token, X-Requested-With, Content-Type, Accept, Authorization'
				headers['Access-Control-Max-Age'] = '1728000'
				render :text => '', :content_type => 'text/plain'
			end
		end

		def set_csrf_cookie_for_ng
			cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
		end
		# Prevent CSRF attacks by raising an exception.
		# For APIs, you may want to use :null_session instead.
		#protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.radd.v1' }

=begin
		rescue_from Exception, with: :generic_exception
		rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

		private

		def record_not_found(error)
			respond_to do |format|
				format.json { render :json => {:error => error.message}, :status => 404 }
			end
		end

		def generic_exception(error)
			respond_to do |format|
				format.json { render :json => {:error => error.message}, :status => 500 }
			end
		end
=end
		protected

		def verified_request?
			super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
		end
	end
end