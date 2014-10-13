class UserStepsController < ApplicationController
	include Wicked::Wizard
	before_filter :set_user_steps
	steps :step1, :step2, :step_final
	before_filter :default_format_json

	def default_format_json
		if (session[:request_format].present? && session[:request_format] == "json")
			request.format = "json"
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
	def redirect_to_finish_wizard
		format.html { redirect_to root_url, notice: "Thanks for Join." }
=begin		
		if (session[:request_format]) && session[:request_format] == "json"
			session[:request_format] = nil
			respond_to do |format|
				format.html {render :status => 200, :json => { :success => trues, :info => "Thanks for Join", :params => {:email => current_user.email, :name => current_user.username, :oauth_token => omniauth['credentials']['token'], :oauth_token_secret => omniauth['credentials']['secret']}}}
			end
		else
			respond_to do |format|
				format.html { redirect_to root_url, notice: "Thanks for Join." }
			end			
		end		
=end		
	end
end
