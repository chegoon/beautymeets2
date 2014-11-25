json.id event.id
json.title event.title
json.description event.description
json.createdAt filtered_time(event.created_at)

json.canShowThumb (event.mobile_thumbnail && event.mobile_thumbnail.image) ? true : false
json.thumbUrl full_url(event.mobile_thumbnail.image_url(:large)) if event.mobile_thumbnail.present?
json.description event.description
json.commentsCount event.comments ? event.comment_threads.count : 0
json.hits event.view_count
