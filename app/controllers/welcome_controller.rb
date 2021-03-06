
class WelcomeController < ApplicationController
	inherit_resources

	#include SimpleCaptcha::ControllerHelpers
	before_filter :detect_browser

	#private
	MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]


	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		@android_detected = true if agent.include? "android" 
=begin
		MOBILE_BROWSERS.each do |m|
			if (agent.include?("and")) && (m == "android")
				#puts "android detected" 
				@android_detected = true
			else
				@android_detected = false
			end
		end
=end		
	end

	def index

		@latest_videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("published_at DESC").limit(9)

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
=begin
  def hello_pusher
    Pusher['public'].trigger('welcome', {
      message: 'hello pusher'
    })
    respond_to do |format|
    	format.html { redirect_to root_path }
    end
  end
=end
end
