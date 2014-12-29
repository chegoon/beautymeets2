#basic_info
json.header @collection.class.to_s
json.id @collection.id
json.description @collection.description
json.title @collection.title
json.hits @collection.view_count
json.thumbUrl full_url(@collection.thumbnail.image_url(:large)) if @collection.thumbnail
json.url request.protocol + request.host_with_port + collection_path(@collection)

if @collection.collectings.count >= 1
	json.canShowRelated true

	json.posts @collection.collectings.each do |col|
		post = col.collectable.class.find(col.collectable_id)
		json.partial! 'api/v1/posts/related_post', post: post
	end
end