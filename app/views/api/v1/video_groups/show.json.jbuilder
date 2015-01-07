json.id @video_group.id

json.author do
	json.canShowThumb @video_group.thumb_url ? true : false
	json.thumbUrl @video_group.thumb_url if @video_group.thumb_url
	json.name @video_group.name
	json.description @video_group.description
end



# comments partial
if @posts.count > 0
	json.posts @posts do |post|
		json.partial! 'api/v1/posts/post', post: post
	end
end