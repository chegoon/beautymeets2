json.favorites @favorites do |fav|
	json.id fav.model_id
	json.postType BookmarkType.find(fav.model_type_id).model
	json.title (BookmarkType.find(fav.model_type_id).model + 's').classify.constantize.find(fav.model_id).title
	json.createdAt time_ago_in_words(fav.created_at)
	
	if BookmarkType.find(fav.model_type_id).model.classify.constantize.to_s == "Video"
		json.thumbUrl BookmarkType.find(fav.model_type_id).model.classify.constantize.find(fav.model_id).thumb_url
	else
		json.thumbUrl full_url(BookmarkType.find(fav.model_type_id).model.classify.constantize.find(fav.model_id).thumbnail.image_url) 
	end

	json.description truncate(BookmarkType.find(fav.model_type_id).model.classify.constantize.find(fav.model_id).description, 50)
end