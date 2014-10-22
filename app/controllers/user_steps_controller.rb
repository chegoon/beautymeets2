class UserStepsController < ApplicationController
	include Wicked::Wizard
	before_filter :set_user_steps
	steps :step1, :step2, :step_final
	before_filter :default_format_check

	def default_format_check
		if (session[:request_format].present? && session[:request_format] == "json")
			request.format = "application/json"
		end
	end

	def show
		render_wizard
	end
	
	def update
		@member.attributes = params[:member]

		render_wizard @member
	end


	private
	def set_user_steps
		@user = current_user
		@member = @user.profile
	end

	private
	def finish_wizard_path #redirect_to_finish_wizard is error
		if session[:request_format] == "json"
			respond_to do |format|
				format.json {render json: {status: 200, success: true, info: "Thanks for Join", params: {email: current_user.email, name: current_user.username, oauth_token: omniauth['credentials']['token'], oauth_token_secret: omniauth['credentials']['secret']}}}
			end
		else 
			root_url
		end			
	end
end
