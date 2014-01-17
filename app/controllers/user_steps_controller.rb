class UserStepsController < ApplicationController
  include Wicked::Wizard
  before_filter :set_user_steps
  steps :skin_type, :skin_tone, :skin_trouble
  
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
