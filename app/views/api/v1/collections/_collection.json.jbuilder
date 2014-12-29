#basic_info
json.id collection.id
json.title collection.title
json.thumbUrl full_url(collection.thumbnail.image_url(:large))
json.url request.protocol + request.host_with_port + collection_path(collection)
json.commentsCount collection.comments.count