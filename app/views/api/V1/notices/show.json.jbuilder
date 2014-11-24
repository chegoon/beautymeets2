json.id @notice.id
json.title @notice.title
json.description @notice.description
json.createdAt filtered_time(@notice.created_at)
json.hits @notice.view_count
json.postType @notice.class.name.underscore.humanize

# comments partial
if @notice.id == 2
	if @comments.count > 0
		json.totalComments @notice.comments.count

		json.comments @comments do |comment|
			json.partial! comment
		end
	end
end