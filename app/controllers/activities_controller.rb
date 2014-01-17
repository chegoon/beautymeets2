class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order("created_at desc")
    @user = current_user
    @member = @user.profile
  end
end
