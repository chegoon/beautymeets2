json.id comment.id
if comment.parent_id
	json.isChild true
else
	json.isChild false
end

json.author do
	if comment.author
		json.name comment.author.name ? comment.author.name : comment.author.email
	end
end

json.body comment.body
json.createdAt filtered_time(comment.created_at)
json.voted @user.voted_for?(comment)  