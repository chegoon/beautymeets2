post_type = post.class.name.underscore.humanize
json.id post.id
json.postType post_type
json.title post.title
json.category post.categories.map(&:name)
json.hits post.view_count
json.commentsCount post.comments.count
json.unread post.unread?(@user)

if post.class.name.underscore.humanize == "Video"
	json.thumbUrl post.thumb_url
else
	json.thumbUrl request.protocol + request.host_with_port + post.thumbnail.image_url
end

json.author do
	if post_type == "Video"
		json.name post.video_group.name
		json.thumbUrl post.video_group.thumb_url
	#elsif post_type  == "Tutorial"
		#json.name post.author.username
		#json.thumbUrl full_url(post.author.image_url)
	elsif post_type == "Item"
		json.name "#{post.tutorials.where(published: true).order("created_at DESC").first.try(:title)}"
	else
		json.name "BEAUTYMEETS Editor"
		json.thumbUrl full_url(User.find(4).image_url)
	end
end 

if post_type == "Tutorial"
	json.isVideoPlayable true
	json.favorites Bookmark.where(model_type_id: 2, model_id: post.id).count
	json.favorited Bookmark.where(model_type_id: 2, model_id: post.id, user_id: @user.id).count > 0  ? 1 : nil
	json.url tutorial_url(post)
	
elsif post_type == "Video"
	json.isVideoPlayable true
	json.favorites Bookmark.where(model_type_id: 3, model_id: post.id).count
	json.favorited Bookmark.where(model_type_id: 3, model_id: post.id, user_id: @user.id).count > 0  ? 1 : nil
	json.url video_url(post)

elsif post_type == "Post"
	json.isVideoPlayable false
	json.favorites Bookmark.where(model_type_id: 5, model_id: post.id).count
	json.favorited Bookmark.where(model_type_id: 5, model_id: post.id, user_id: @user.id).count > 0  ? 1 : nil
	json.url post_url(post)
else
	json.isVideoPlayable false
	json.favorites Bookmark.where(model_type_id: 1, model_id: post.id).count
	json.favorited Bookmark.where(model_type_id: 1, model_id: post.id, user_id: @user.id).count > 0  ? 1 : nil
	json.url video_url(post)
end							