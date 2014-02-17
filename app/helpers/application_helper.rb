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
		request.protocol + request.host_with_port + image_url
	end
	
	def truncate(text, len, tail = '..')
		if text.present?
			unpacked = text.unpack('U*') 
			unpacked.length > len ? unpacked[0..len-1].pack('U*') + tail : text
		end
	end
end
