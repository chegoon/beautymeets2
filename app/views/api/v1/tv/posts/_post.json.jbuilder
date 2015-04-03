post_type = post.class.name.underscore.humanize

json.description post.description

if post_type == "Item" || post_type == "Post"
	json.sources do
		ar = Array.new
		ar << ""
		json.array! ar
	end
else
	json.sources do
		ar = Array.new
		ar << post.video_url
		json.array! ar
	end
end

if post_type == "Video"
	json.card post.thumb_url
	json.background post.thumb_url
	json.title post.title
	json.studio post.video_group.name
else
	json.card request.protocol + request.host_with_port + post.thumbnail.image_url
	json.background request.protocol + request.host_with_port + post.thumbnail.image_url
	json.title post.title
	json.studio post.author.username
end

if (post_type == "Post") || (post_type == "Item")
	json.images do
		ar = Array.new
		post.pictures.each do |pic|
			ar << request.protocol + request.host_with_port + pic.image_url if !pic.image_url.nil?
		end
		json.array! ar
	end
end

json.category post.categories.map(&:name)
json.hits post.view_count
