
#json.author do
	json.id @author.id
	if @author.class.to_s == "User"
		json.canShowThumb @author.image_url ? true : false
		json.thumbUrl full_url(@author.image_url)
		json.name @author.username
		json.subHeader "#{@total_posts_count} Posts"
	elsif @author.class.to_s == "VideoGroup"
		json.canShowThumb @author.thumb_url ? true : false
		json.thumbUrl @author.thumb_url
		json.name @author.name
		#json.description @author.description
		json.subHeader "#{@total_posts_count} Posts"
	elsif @author.class.to_s == "Brand"
		json.canShowThumb @author.thumbnail.image_url ? true : false
		json.thumbUrl full_url(@author.thumbnail.image_url(:medium))
		json.name @author.name
		json.description @author.description
		json.subHeader "#{@total_posts_count} Items"
	else
	end
	json.total_posts_count @total_posts_count
	# posts partial
	if @posts.count > 0
		json.posts @posts do |post|
			json.partial! 'api/v1/posts/post', post: post
		end
	end
#end