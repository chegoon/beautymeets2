json.id event.id
json.title event.title
json.description event.description
json.createdAt filtered_time(event.created_at)

if (event.released_at <= Time.now) && (event.finish_on >= Time.now) && (event.published == TRUE)
	json.canPlay true
else
	json.canPlay false
end

json.canShowThumb (event.mobile_thumbnail && event.mobile_thumbnail.image) ? true : false
json.thumbUrl full_url(event.mobile_thumbnail.image_url) if event.mobile_thumbnail.present?

json.description event.description
json.commentsCount event.comments ? event.comment_threads.count : 0
json.hits event.view_count