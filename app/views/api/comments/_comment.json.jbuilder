if comment.parent_id
	json.isChild true
else
	json.isChild false
end

json.author do
	json.name (comment.author && comment.author.name) ? comment.author.name : comment.author.email
end

json.body comment.body
json.createdAt filtered_time(comment.created_at)