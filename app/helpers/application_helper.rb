module ApplicationHelper
	def page_title(title)
		content_for(:page_title) { title }
	end

	def page_thumb(thumb)
		content_for(:page_thumb) { thumb }
	end

	def page_desc(desc)
		content_for(:page_desc) { desc }
	end
	
	def truncate(text, len, tail = '..')
		puts "truncate helper called"
		if text.present?
			unpacked = text.unpack('U*') 
			unpacked.length > len ? unpacked[0..len-1].pack('U*') + tail : text
		end
	end
end
