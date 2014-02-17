
class WelcomeController < ApplicationController
	inherit_resources

  def index

		@blog_rss = SimpleRSS.parse open('http://blog.beautymeets.com/rss')
  	
  	if user_signed_in?
	  	@user = current_user
	    @member = @user.profile
	  	#@notifications = Activity.where(recipient_id: (@member.user || nil), recipient_type: ("User" || nil)).unread_by(current_user).order("created_at desc") if !current_user.has_role? :admin
	    @notifications = Activity.unread_by(current_user)
=begin
	    @best_tutorials = Tutorial.where(published: true).unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
	    @latest_tutorials = Tutorial.where(published: true).unread_by(current_user).order("created_at DESC, updated_at DESC").limit(4)
	    @best_videos = Video.where(published: true).unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
	    @latest_videos = Video.where(published: true).unread_by(current_user).order("created_at DESC").limit(4)
	    @items = Item.unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
=end

	    @best_tutorials = Tutorial.where(published: true).order("view_count DESC, created_at DESC").limit(2)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
	    @best_beautyclasses = Beautyclass.where(published: true, closed: false).order("view_count DESC, updated_at DESC").limit(2)
	    @best_videos = Video.where(published: true).order("view_count DESC, created_at DESC").limit(4)
	    @latest_videos = Video.where(published: true).order("created_at DESC").limit(4)
	    @best_items = Item.order("view_count DESC, created_at DESC").limit(4)
			@latest_items = Item.order("created_at DESC, updated_at DESC").limit(4)
	    
	    @bookmarks = Bookmark.where(user_id: @user.id)
	  else
	    @best_tutorials = Tutorial.where(published: true).order("view_count DESC, created_at DESC").limit(2)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
	    @best_beautyclasses = Beautyclass.where(published: true, closed: false).order("view_count DESC, created_at DESC").limit(2)
	    @best_videos = Video.where(published: true).order("view_count DESC, created_at DESC").limit(4)
	    @latest_videos = Video.where(published: true).order("created_at DESC").limit(4)
	    @best_items = Item.order("view_count DESC, created_at DESC").limit(4)
			@latest_items = Item.order("created_at DESC, updated_at DESC").limit(4)
	  end
  end
end
