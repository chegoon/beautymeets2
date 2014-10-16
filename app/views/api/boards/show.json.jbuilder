json.id @board.id
json.title @board.title
json.postType "Board"
json.author do
	if @board.author
		json.name @board.author.name ? @board.author.name : @board.author.email
	end
end
json.canShowThumb @board.picture.image ? true : false
json.thumbUrl full_url(@board.picture.image_url(:large))
json.description @board.description
json.createdAt filtered_time(@board.created_at)


if @board.comments.count > 0
	json.comments @board.comments do |comment|
		json.partial! comment
	end
end