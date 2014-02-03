class WelcomeController < ApplicationController
  def index
  	if user_signed_in?
	  	@activities = PublicActivity::Activity.order("created_at desc")
	    @user = current_user
	    @member = @user.profile

=begin
	    @best_tutorials = Tutorial.where(published: true).unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
	    @latest_tutorials = Tutorial.where(published: true).unread_by(current_user).order("created_at DESC, updated_at DESC").limit(4)
	    @best_videos = Video.where(published: true).unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
	    @latest_videos = Video.where(published: true).unread_by(current_user).order("created_at DESC").limit(4)
	    @items = Item.unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
=end

	    @best_tutorials = Tutorial.where(published: true).order("view_count DESC, created_at DESC").limit(4)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(4)
	    @best_beautyclasses = Beautyclass.where(published: true, closed: false).order("created_at DESC, updated_at DESC").limit(2)
	    @best_videos = Video.where(published: true).order("view_count DESC, created_at DESC").limit(4)
	    @lastest_videos = Video.where(published: true).order("created_at DESC").limit(4)
	    @best_items = Item.order("view_count DESC, created_at DESC").limit(4)
			@latest_items = Item.order("created_at DESC, updated_at DESC").limit(4)
	    
	    @bookmarks = Bookmark.where(user_id: @user.id)
	  else
	    @best_tutorials = Tutorial.where(published: true).order("view_count DESC, created_at DESC").limit(3)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(3)
	    @best_beautyclasses = Beautyclass.where(published: true, closed: false).order("view_count DESC, created_at DESC").limit(2)
	    @best_videos = Video.where(published: true).order("view_count DESC, created_at DESC").limit(4)
	    @latest_videos = Video.where(published: true).order("created_at DESC").limit(4)
	    @best_items = Item.order("view_count DESC, created_at DESC").limit(4)
			@latest_items = Item.order("created_at DESC, updated_at DESC").limit(4)
	  end
  end
end
