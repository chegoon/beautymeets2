
class WelcomeController < ApplicationController
	inherit_resources

  def index

		@blog_rss = SimpleRSS.parse open('http://blog.beautymeets.com/rss')
  	
  	if user_signed_in?
	  	@user = current_user
	    @member = @user.profile
	    @notifications = Activity.unread_by(current_user)

			@events = Event.where('released_at <= ? AND announcement_closed_at >= ?  AND published = TRUE', Time.now, Time.now).order("created_at DESC")

	    @best_tutorials = Tutorial.joins("JOIN impressions ON impressions.impressionable_id = tutorials.id").where("impressions.impressionable_type = 'Tutorial' AND (impressions.created_at > CURDATE() - INTERVAL 2 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(2)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
			@best_items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at > CURDATE() - INTERVAL 2 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(4)
			@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("created_at DESC, updated_at DESC").limit(4)
	    @latest_posts = Post.where(published: true).order("created_at DESC, updated_at DESC").limit(3)

	    @bookmarks = Bookmark.where(user_id: @user.id)
	    @tutorials = @best_tutorials
	  else
	  	@events = Event.where('released_at <= ? AND announcement_closed_at >= ? AND published = TRUE', Time.now, Time.now).order("created_at DESC")

	    @best_tutorials = Tutorial.joins("JOIN impressions ON impressions.impressionable_id = tutorials.id").where("impressions.impressionable_type = 'Tutorial' AND (impressions.created_at > CURDATE() - INTERVAL 2 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(2)
	    @latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
	    @best_items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at > CURDATE() - INTERVAL 2 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(4)			
			@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("created_at DESC, updated_at DESC").limit(4)
			@latest_posts = Post.where(published: true).order("created_at DESC, updated_at DESC").limit(3)
			@tutorials = @best_tutorials
	  end
  end
end
