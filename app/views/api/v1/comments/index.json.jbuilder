if @comments.count > 0

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