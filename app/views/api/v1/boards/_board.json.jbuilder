json.id board.id
json.title board.title
json.author do
	if board.author
		json.thumbUrl full_url(board.author.image_url(:small)) if board.author.image.present?
		json.name board.author.name ? board.author.name : board.author.email
	end
end

json.canShowThumb (board.picture && board.picture.image) ? true : false
json.thumbUrl full_url(board.picture.image_url(:large)) if board.picture.present?
json.description board.description
json.commentsCount board.comments ? board.comments.count : 0
json.createdAt filtered_time(board.created_at)