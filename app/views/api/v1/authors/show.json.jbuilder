
#json.author do
	json.id @author.id
	if @author.class.to_s == "User"
		json.canShowThumb @author.image_url ? true : false
		json.thumbUrl full_url(@author.image_url)
		json.name @author.username
		json.description ""
	elsif @author.class.to_s == "VideoGroup"
		json.canShowThumb @author.thumb_url ? true : false
		json.thumbUrl @author.thumb_url
		json.name @author.name
		json.description @author.description
	elsif @author.class.to_s == "Brand"
		json.canShowThumb @author.thumbnail.image_url ? true : false
		json.thumbUrl full_url(@author.thumbnail.image_url(:medium))
		json.name @author.name
		json.description @author.description
	else
	end
	# posts partial
	if @posts.count > 0
		json.posts @posts do |post|
			json.partial! 'api/v1/posts/post', post: post
		end
	end
#end