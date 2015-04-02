json.googlevideos do
	json.array! do 
		json.category "category"
		
		json.videos do
			json.array! @posts do |p|
				json.partial! 'api/v1/tv/posts/post', post: p
			end
		end
	end
end