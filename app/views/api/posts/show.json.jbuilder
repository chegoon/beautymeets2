json.id @post.id

json.title @post.title

json.author do
	json.name @post.author.name
end 

json.description @post.description

json.hits @post.view_count

if @post.class.name == "Video"
	json.thumbUrl  @post.thumb_url
	json.videoUrl '<iframe width="100%" height="280px;" src="' + @post.video_url + '" frameborder="0" allowfullscreen></iframe>'
	
elsif @post.class.name == "Tutorial"
	json.videoUrl '<iframe  width="100%" src="' + @post.vimeo_url + '?title=0&amp;byline=0&amp;portrait=0&amp;color=5de0cf" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
	json.items @post.items do |item|
		json.name item.name
		json.brandName item.brand.try(:name)
		json.thumbUrl full(item.thumbnail.image_url)
	end
elsif @post.class.name == "Post"
	json.images @post.pictures do |picture|
		json.image full_url(picture.image_url)
	end
else
	json.thumbUrl  full_url(@post.thumbnail.image_url)
end

json.tags @post.tags :name

json.comments @post.comments do |comment|
	json.author do
		json.name comment.author.name
	end
	json.body comment.body
	json.cratedAt comment.created_at
end