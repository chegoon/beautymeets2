json.id comment.id
if comment.parent_id
	json.isChild true
else
	json.isChild false
end

json.author do
	if comment.author
		json.thumbUrl comment.author.image ? full_url(comment.author.image_url) : ""
		json.name comment.author.name ? comment.author.name : comment.author.email
	end
end

json.body comment.body
json.createdAt filtered_time(comment.created_at)
json.voted @user.voted_for?(comment)  
json.votes comment.votes_for.size