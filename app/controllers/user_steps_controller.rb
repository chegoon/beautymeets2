class UserStepsController < ApplicationController
	include Wicked::Wizard
	before_filter :set_user_steps
	steps :step1, :step2, :step_final
	
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
end
