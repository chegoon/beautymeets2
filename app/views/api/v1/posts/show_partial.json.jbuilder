#basic_info
json.header @post.class.to_s
json.id @post.id
json.postType @post.class.name.underscore.humanize
json.title @post.title
json.hits @post.view_count
json.tags @post.tags :name

#author_info
if @post.class.name == "Item"
	json.canShowAuthor false
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
	json.description truncate(@post.description, 100)
	json.canShowVideo true
	json.videoUrl '<iframe width="100%" height="280px;" src="' + @post.video_url + '" frameborder="0" allowfullscreen></iframe>'
	json.favorited Bookmark.where(model_type_id: 3, model_id: @post.id, user_id: @user.id).count > 0  ? 1 : nil

elsif @post.class.name == "Tutorial"
	json.description @post.description
	json.canShowVideo true
	json.videoUrl '<iframe  width="100%" src="' + @post.vimeo_url + '?title=0&amp;byline=0&amp;portrait=0&amp;color=5de0cf" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
	json.favorited Bookmark.where(model_type_id: 2, model_id: @post.id, user_id: @user.id).count > 0  ? 1 : nil

	if @post.items.count > 0
		json.canShowItems true
		json.items @post.items do |item|
			json.name item.name
			json.brandName item.brand.try(:name)
			json.thumbUrl full_url(item.thumbnail.image_url(:very_small))
		end
	end

elsif @post.class.name == "Post" 
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
		json.items items_in_category.limit(10) do |item|
			json.id item.id
			json.postType "item"
			json.name item.name
			json.brandName item.brand.try(:name)
			json.thumbUrl full_url(item.thumbnail.image_url(:very_small))
		end
	end
else
	json.canShowVideo false
	json.canShowImages false
	json.canShowItems false
end

=begin
# comments partial
if @comments.count > 0
	#json.cuurent_comment_page @comment_page_index
	#json.first_comment_page 1
	#json.prev_comment_page (cuurent_comment_page - 1) > 0 ? cuurent_comment_page - 1 : 
	#json.next_comment_page 
	#json.last_comment_page
	#json.comments @comments do |comment|
		json.partial! comment

		if comment.has_children?
			json.partial! comment
			json.array! comment.children do |ch|
				json.partial! 'api/comments/comment', comment: ch
			end
		else
			json.partial! comment
		end

	end
end
=end