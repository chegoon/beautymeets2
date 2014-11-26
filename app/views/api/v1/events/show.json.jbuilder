json.id @event.id
json.title @event.title
json.description @event.description
json.createdAt filtered_time(@event.created_at)
json.hits @event.view_count
json.postType @event.class.name.underscore.humanize

if (@event.pictures.present?) && (@event.pictures.count > 0)
	json.canShowImage true
	json.images @event.pictures do |pic|
		if (pic.id != @event.mobile_thumbnail.id) && (pic.id != @event.thumbnail.id)		
			json.url full_url(pic.image_url)
		end
	end
else
	json.canShowImage false
end

json.startFrom if @event.startFrom?
json.finishOn if @event.finishOn?
json.winReleasedAt if @event.winReleasedAt?
json.targetUrl if @event.targetUrl?

# comments partial
if @comments.count > 0
	json.totalComments @event.comments.count.to_i

	json.comments @comments do |comment|
		json.partial! comment
	end
end