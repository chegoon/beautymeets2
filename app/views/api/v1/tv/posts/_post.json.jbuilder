post_type = post.class.name.underscore.humanize
json.id post.id
json.postType post_type
json.title truncate(post.title, 24)
json.category post.categories.map(&:name)
json.hits post.view_count

json.description post.description
json.card request.protocol + request.host_with_port + post.thumbnail.image_url
json.background request.protocol + request.host_with_port + post.thumbnail.image_url

if post.class.name.underscore.humanize == "Video"
	json.thumbUrl post.thumb_url
else
	json.thumbUrl request.protocol + request.host_with_port + post.thumbnail.image_url
end


if post_type == "Video"
	json.studio post.video_group.name
#elsif post_type  == "Tutorial"
	json.studio post.author.username
elsif post_type == "Item"
	#json.name "#{post.tutorials.where(published: true).order("created_at DESC").first.try(:title)}"
	if post.tutorials.present?
		json.studio "#{post.tutorials.where(published: true).order("created_at DESC").first.try(:title)}"
	else
		json.studio "#{post.videos.where(published: true).order("created_at DESC").first.try(:title)}"
	end
else
	json.studio "BEAUTYMEETS Editor"
end

if post_type == "Tutorial"
	json.isVideoPlayable true
	json.url tutorial_url(post)
	
elsif post_type == "Video"
	json.isVideoPlayable true
	json.url video_url(post)

elsif post_type == "Post"
	json.isVideoPlayable false
	json.url post_url(post)
else
	json.isVideoPlayable false
	json.url video_url(post)
end							