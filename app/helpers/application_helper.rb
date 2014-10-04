module ApplicationHelper
	def resource_name 
		:user 
	end 

	def resource 
		@resource ||= User.new 
	end 

	def devise_mapping 
		@devise_mapping ||= Devise.mappings[:user] 
	end 

	def resource_class 
		User 
	end
	
	def page_title(title)
		content_for(:page_title) { title }
	end

	def page_thumb(thumb)
		content_for(:page_thumb) { thumb }
	end

	def page_desc(desc)
		content_for(:page_desc) { desc }
	end

	def full_url(image_url)
		if image_url
			request.protocol + request.host_with_port + image_url
		end
	end
	
	def truncate(text, len, tail = '..')
		if text.present?
			unpacked = text.unpack('U*') 
			unpacked.length > len ? unpacked[0..len-1].pack('U*') + tail : text
		end
	end

	def filtered_number(num)
		if user_signed_in? && current_user.has_role?(:admin)
			return num
		elsif num.nil?
			return "0"
		elsif (0..10).include?(num)
			return num
		elsif (11..50).include?(num)
			return "10+"
		elsif (51..100).include?(num)
			return "50+"
		elsif (101..300).include?(num)
			return "100+"
		elsif (301..500).include?(num)
			return "300+"
		elsif (501..1000).include?(num)
			return "500+"
		elsif (1001..5000).include?(num)
			return "1,000+"
		elsif (5001..10000).include?(num)
			return "5,000+"
		else
			return "10,000+"
		end
	end	

	def filtered_time(time)
		if  (Time.zone.now - time).to_i / 1.month
			return time_ago_in_words(time).to_s + " ago"
		else
			return time.strftime("%Y-%m-%d %H:%M")
		end
	end

	def sortable(column, title = nil)  
		title ||= column.titleize  
		direction = (column == params[:sort] && params[:direction] == "ASC") ? "DESC" : "ASC"  
		link_to title, :sort => column, :direction => direction  
	end  
end
