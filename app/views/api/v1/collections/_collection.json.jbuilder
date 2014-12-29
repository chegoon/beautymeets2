#basic_info
json.id col.id
json.title col.title
json.thumbUrl full_url(col.thumbnail.image_url(:large)) if col.thumbnail
json.url request.protocol + request.host_with_port + collection_path(col)
json.commentsCount col.comments.count