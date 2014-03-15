
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
			
			#@events = Event.where('released_at <= ? AND finish_on >= ? ', Time.now, Time.now).order("created_at DESC")
	    @best_tutorials = Tutorial.where(published: true, created_at: (8.week.ago)..(Time.now), updated_at: (2.week.ago)..(Time.now)).order("view_count DESC, created_at DESC").limit(2)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
	    #@best_beautyclasses = Beautyclass.where(published: true, closed: false).order("view_count DESC, updated_at DESC").limit(2)
	    #@best_videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").unread_by(current_user).order("view_count DESC, created_at DESC").limit(4)
	    #@latest_videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").unread_by(current_user).order("published_at DESC").limit(4)
	    @best_items = Item.where(created_at: (8.week.ago)..(Time.now), updated_at: (2.week.ago)..(Time.now)).order("view_count DESC, created_at DESC").limit(4)
			@latest_items = Item.order("created_at DESC, updated_at DESC").limit(4)
	    @latest_posts = Post.order("created_at DESC, updated_at DESC").limit(3)
	    @bookmarks = Bookmark.where(user_id: @user.id)
	  else
	  	#@events = Event.where('released_at <= ? AND finish_on >= ? ', Time.now, Time.now).order("created_at DESC")
	    @best_tutorials = Tutorial.where(published: true, created_at: (8.week.ago)..(Time.now), updated_at: (2.week.ago)..(Time.now)).order("view_count DESC, created_at DESC").limit(2)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
	    #@best_beautyclasses = Beautyclass.where(published: true, closed: false).order("view_count DESC, created_at DESC").limit(2)
	    #@best_videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("view_count DESC, created_at DESC").limit(4)
	    #@latest_videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("published_at DESC").limit(4)
	    @best_items = Item.where(created_at: (8.week.ago)..(Time.now), updated_at: (2.week.ago)..(Time.now)).order("view_count DESC, created_at DESC").limit(4)
			@latest_items = Item.order("created_at DESC, updated_at DESC").limit(4)
			@latest_posts = Post.order("created_at DESC, updated_at DESC").limit(3)
	  end
  end
end
