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

json.startFrom @event.start_from.strftime("%Y.%m.%d %H:%M") if @event.start_from?
json.finishOn @event.finish_on.strftime("%Y.%m.%d %H:%M") if @event.finish_on?
json.winReleasedAt @event.win_released_at.strftime("%Y.%m.%d %H:%M") if @event.win_released_at?
json.targetUrl @event.target_url if @event.target_url?
json.releasedAt @event.released_at.strftime("%Y.%m.%d %H:%M") if @event.released_at.present?
# comments partial
=begin
if @comments.count > 0
	json.totalComments @event.comments.count.to_i

	json.comments @comments do |comment|
		json.partial! comment
	end
end
=end