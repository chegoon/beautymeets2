json.id @event.id
json.title @event.title
json.description @event.description
json.createdAt filtered_time(@event.created_at)
json.hits @event.view_count
json.postType @event.class.name.underscore.humanize

# comments partial
if @comments.count > 0
	json.totalComments @event.comments.count

	json.comments @comments do |comment|
		json.partial! comment
	end
end