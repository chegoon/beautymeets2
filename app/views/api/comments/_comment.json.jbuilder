json.id comment.id
json.isChild comment.parent_id ? true : false

json.author do
	if comment.author
		json.thumbUrl comment.author.image ? full_url(comment.author.image_url) : ""
		json.name comment.author.name ? comment.author.name : comment.author.email
	end
end

json.body comment.body
json.createdAt filtered_time(comment.created_at)
json.votable ((@user.can_vote?(comment)) && (@user.id != comment.author.id))
json.voted @user.voted_for?(comment)  
json.votes comment.votes_for.size

if comment.picture
	json.attachmentVisible true
	json.attachement do
		json.thumbUrl full_url(comment.picture.image_url(:medium))
	end
else
	json.attachmentVisible false
end

json.deletable @user.can_delete?(comment)