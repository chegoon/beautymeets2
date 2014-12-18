json.id @board.id
json.title @board.title
json.postType "Board"
json.author do
	if @board.author
		json.name @board.author.name ? @board.author.name : @board.author.email
		json.thumbUrl full_url(@board.author.image_url(:small)) if @board.author.image.present?
	end
end
json.canShowThumb (@board.picture && @board.picture.image) ? true : false
json.thumbUrl full_url(@board.picture.image_url) if @board.picture.present?

json.description @board.description
json.createdAt filtered_time(@board.created_at)
json.deletable @user.can_delete?(@board)

# comments partial
=begin
if @comments.count > 0
	json.comments @comments do |comment|
		json.partial! comment
	end
end
=end
