
class WelcomeController < ApplicationController
	inherit_resources

	def index
			
		if user_signed_in?
		
			@user = current_user
			@member = @user.profile
			@notifications = Activity.unread_by(current_user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc") if current_user.has_role?(:member)

			@events = Event.where('released_at <= ? AND announcement_closed_at >= ?  AND published = TRUE', Time.now, Time.now).order("created_at DESC")

			@best_tutorials = Tutorial.joins("JOIN impressions ON impressions.impressionable_id = tutorials.id").where("impressions.impressionable_type = 'Tutorial' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(2)
			@latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
			#@latest_tutorials = Tutorial.where(published: true).last(2)
			@best_items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(4)
			@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("created_at DESC, updated_at DESC").limit(4)
			#@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).last(4).order("created_at DESC")
			@latest_posts = Post.where(published: true).order("created_at DESC, updated_at DESC").limit(3)
			#@latest_posts = Post.where(published: true).last(3).order("created_at DESC")

			@bookmarks = Bookmark.where(user_id: @user.id)
			@tutorials = @best_tutorials
		else
			@events = Event.where('released_at <= ? AND announcement_closed_at >= ? AND published = TRUE', Time.now, Time.now).order("created_at DESC")

			@best_tutorials = Tutorial.joins("JOIN impressions ON impressions.impressionable_id = tutorials.id").where("impressions.impressionable_type = 'Tutorial' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(2)
			@latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
			@best_items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(4)			
			@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("created_at DESC, updated_at DESC").limit(4)
			@latest_posts = Post.where(published: true).order("created_at DESC, updated_at DESC").limit(3)
			@tutorials = @best_tutorials
		end
	end

	def feed 
		


		@best_tutorials = Tutorial.joins("JOIN impressions ON impressions.impressionable_id = tutorials.id").where("impressions.impressionable_type = 'Tutorial' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(2)
		#@latest_tutorials = Tutorial.where(published: true).order("created_at DESC, updated_at DESC").limit(2)
		@latest_tutorials = Tutorial.where(published: true).last(2)
		@best_items = Item.joins("JOIN impressions ON impressions.impressionable_id = items.id").where("impressions.impressionable_type = 'Item' AND (impressions.created_at > CURDATE() - INTERVAL 1 WEEK)").group("impressions.impressionable_id").order("count(impressions.impressionable_id) DESC").limit(4)			
		#@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("created_at DESC, updated_at DESC").limit(4)
		@latest_items = Item.where("id IN (?)", Itemization.pluck(:item_id)).last(4).order("created_at DESC")
		#@latest_posts = Post.where(published: true).order("created_at DESC, updated_at DESC").limit(3)
		@latest_posts = Post.where(published: true).last(3).order("created_at DESC")

		respond_to do |format|
			format.atom
			format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
		end
	end

  def hello_pusher
    Pusher['public'].trigger('welcome', {
      message: 'hello pusher'
    })
    respond_to do |format|
    	format.html { redirect_to root_path }
    end
  end
end
