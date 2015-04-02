json.description post.description
json.sources do
	ar = Array.new
	ar << post.video_url
	json.array! ar
end
json.card request.protocol + request.host_with_port + post.thumbnail.image_url
json.background request.protocol + request.host_with_port + post.thumbnail.image_url
json.title post.title
json.studio post.author.username

json.category post.categories.map(&:name)
json.hits post.view_count

if post.class.name.underscore.humanize == "Video"
	json.thumbUrl post.thumb_url
else
	json.thumbUrl request.protocol + request.host_with_port + post.thumbnail.image_url
end