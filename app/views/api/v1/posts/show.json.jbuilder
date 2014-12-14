#basic_info
json.header @post.class.to_s
json.id @post.id
json.postType @post.class.name.underscore.humanize
json.title @post.title
json.hits @post.view_count
json.tags @post.tags :name

#author_info
if @post.class.name == "Item"
	json.canShowAuthor true
	json.author do 
		json.name @post.brand.name
		json.thumbUrl full_url(@post.brand.thumbnail.image_url(:very_small))
	end
else
	json.canShowAuthor true
	json.author do
		if @post.class.name == "Video"
			json.name @post.video_group.name
			json.thumbUrl @post.video_group.thumb_url
		elsif @post.class.name == "Tutorial"
			json.name @post.author.username
			json.thumbUrl full_url(@post.author.image_url)
		else
			json.name "BEAUTYMEETS"
			json.thumbUrl full_url(User.find(4).image_url)
		end
	end 
end

#main_info
if @post.class.name == "Video"

	json.thumbUrl @post.thumb_url
	json.description truncate(@post.description, 100)
	json.canShowVideo true
	json.videoUrl '<iframe width="100%" height="280px;" src="' + @post.video_url + '" frameborder="0" allowfullscreen></iframe>'
	json.favorited Bookmark.where(model_type_id: 3, model_id: @post.id, user_id: @user.id).count > 0  ? 1 : nil

elsif @post.class.name == "Tutorial"
	json.thumbUrl full_url(@post.thumbnail.image_url(:large))
	json.description @post.description
	
	if @post.video_url.present?
		json.canShowVideo true
		json.videoUrl '<iframe width="100%" height="280px;" src="' + @post.video_url + '?rel=0&vq=hd720&showsearch=0" frameborder="0" allowfullscreen></iframe>'
		
	elsif @post.vimeo_url.present?
		json.canShowVideo true
		json.videoUrl '<iframe  width="100%" src="' + @post.vimeo_url + '?title=0&amp;byline=0&amp;portrait=0&amp;color=5de0cf" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
	else
		json.canShowVideo false
	end

	json.favorited Bookmark.where(model_type_id: 2, model_id: @post.id, user_id: @user.id).count > 0  ? 1 : nil

	if @post.items.count > 0
		json.canShowItems true
		json.relatedItemTitle "#{@post.title}에 사용된 제품"
		json.items @post.items do |item|
			json.id item.id
			json.postType "Item"
			json.name item.name
			json.brandName item.brand.try(:name)
			json.thumbUrl full_url(item.thumbnail.image_url(:very_small))
		end
	end

elsif @post.class.name == "Post" 
	json.thumbUrl full_url(@post.thumbnail.image_url(:large))
	json.description @post.description
	json.canShowVideo false
	json.favorited Bookmark.where(model_type_id: 5, model_id: @post.id, user_id: @user.id).count > 0  ? 1 : nil

	# post image slides
	if @post.pictures.count > 0
		json.canShowImages true
		json.images @post.pictures do |picture|
			json.thumbUrl full_url(picture.image_url(:large))
		end
	end
	
elsif @post.class.name == "Item"
	json.thumbUrl full_url(@post.thumbnail.image_url(:large))
	json.description @post.description
	json.canShowVideo false
	json.favorited Bookmark.where(model_type_id: 1, model_id: @post.id, user_id: @user.id).count > 0  ? 1 : nil

	#thumbnail slides
	if @post.pictures.count > 0
		json.canShowImages true
		json.images @post.pictures do |picture|
			json.thumbUrl full_url(picture.image_url(:large))
		end
	end

	p_cat_ids = Array.new
	@post.categories.each do |cat|
		p_cat_ids.push(cat.parent.id) if cat.parent
	end
	sibling_categories = Category.where("parent_id IN (?)", p_cat_ids)
	item_ids_in_category = Item.joins(:categories).where("category_id IN (?) AND items.id <> ?", sibling_categories.map(&:id), @post.id).select("distinct(items.id)")
	items_in_category = Item.where("id IN (?)", item_ids_in_category.map(&:id)).order("view_count DESC")

	if items_in_category.count > 0
		json.canShowItems true
		json.relatedItemTitle "같은 카테고리 인기제품"
		json.items items_in_category.limit(10) do |item|
			json.id item.id
			json.postType "item"
			json.name item.name
			json.brandName item.brand.try(:name)
			json.thumbUrl full_url(item.thumbnail.image_url(:small))
		end
	end
else
	json.canShowVideo false
	json.canShowImages false
	json.canShowItems false
end

if @related_posts.count >= 1
	json.canShowRelated true
	if @post.class.name == "Item"
		json.relatedVideoTitle "#{@post.title}이 사용된 영상"
	else
		json.relatedVideoTitle "이런 영상 어때요?"
	end
	json.relatedPosts @related_posts do |post|
		json.partial! 'api/posts/post', post: post
	end
end

# comments partial
=begin
if @comments.count > 0
	json.totalComments @post.comments.count
	#json.currentCommentPage @post.comments.current_page
	#json.totalCommentPage @post.comments.total_page

	json.comments @comments do |comment|
		json.partial! comment
	end
end
=end