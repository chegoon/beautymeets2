json.id @board.id
json.title @board.title
json.postType "Board"
json.author do
	if @board.author
		json.name @board.author.name ? @board.author.name : @board.author.email
	end
end
json.canShowThumb (@board.picture && @board.picture.image) ? true : false
json.thumbUrl full_url(@board.picture.image_url(:large)) if @board.picture.present?
json.description @board.description
json.createdAt filtered_time(@board.created_at)


# comments partial
if @comments.count > 0
	json.totalComments @board.comments.count
	
	json.comments @comments do |comment|
		json.partial! comment
=begin		
		if comment.has_children?
			json.partial! comment
			json.array! comment.children do |ch|
				json.partial! 'api/comments/comment', comment: ch
			end
		else
			json.partial! comment
		end
=end		
	end
end
