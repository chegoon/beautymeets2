class ChannelLog < ActiveRecord::Base
	resourcify
	include Authority::Abilities

	belongs_to :channel_loggable, :polymorphic => true

	has_many :channel_log_details

	belongs_to :channel

	attr_accessible :channel_loggable_id, :channel_loggable_type, :uploaded_at, :url, :channel_name

	def channel_name
		#brand.name if brand
		channel.try(:name)
	end
		
	def channel_name=(name)
		self.channel = Channel.find_or_create_by_name(name) if name.present?
	end

	def self.update_log_details
		channel_logs = ChannelLog.joins("JOIN tutorials ON tutorials.id = channel_logs.channel_loggable_id").where("channel_logs.channel_loggable_type = 'Tutorial' AND tutorials.published = TRUE")
		if channel_logs
			channel_logs.each do |log|
				if log.channel.name == 'Naver TV Cast' 
					if log.url
						#page = Nokogiri::HTML(open(log.url,'r:binary').read.encode("utf-8", invalid: :replace, undef: :replace))
	      				#page = Nokogiri::HTML(open(log.url, 'r:binary').read.encode('utf-8', 'EUC-KR'))
	      				#browser = Watir::Browser.start log.url
	      				#page = Nokogiri::HTML.parse(browser.html)
						
						page = Nokogiri::HTML(open(log.url).read)
	      				detail = log.channel_log_details.new
	      				#if log.channel_log_details.order("collected_at ASC").last 
	      				#prev_detail = log.channel_log_details.order("collected_at ASC").last 

						page.css("#content").each do |mv|	
							
							#detail.like_count = mv.css(".mv_common_area").css(".u_likeit_module").css(".u_cnt").text.delete("^0-9").to_i - prev_detail.like_count.to_i
							#detail.like_count = mv.css(".mv_common_area").css(".u_likeit_module").css(".u_cnt").text.delete("^0-9")
							#detail.comment_count = mv.css(".cbox_list_info").at_css("em").text.delete("^0-9")
							detail.view_count = mv.css(".current_mv_spec").css("dd")[0].at_css("strong").text.delete("^0-9")
							detail.share_count = mv.css(".current_mv_spec").css("dd")[1].at_css("strong").text.delete("^0-9")
							detail.collected_at = DateTime.now
							detail.save
							
						end
						page = nil if page
						#browser.close if browser
					end
				elsif log.channel.name == 'Youtube'
					if log.url
						client = YouTubeIt::Client.new(:username => "hellobeauty@reallplay.com", :password =>  "reallplay0707",:dev_key => "AI39si4kYnOd5LRdnL4B9BIbBOLKPAG9y1O4Wh6a8cO8dvQ-Hsmv_fXPnmEYHu_ndnK0OijXoBtlNyAnzyJYChbuL7cnKsqjJA")
						video = client.my_video(log.url.split("/").last)
						puts video.instance_variables
		      			detail = log.channel_log_details.new

		      			detail.comment_count = video.comment_count
		      			detail.view_count = video.view_count
		      			
		      			detail.collected_at = DateTime.now
		      			detail.save
		      		end
				else
				end 
			end
		end
	end
end