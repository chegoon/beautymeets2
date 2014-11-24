if @comments.count > 0
	
	json.first_page 1
	json.prev_page (@comment_page_index.to_i - 1) > 0 ? @comment_page_index.to_i - 1 : 1
	json.current_page @comment_page_index
	json.next_page (@comment_page_index.to_i + 1 <= @comments.total_pages) ? @comment_page_index.to_i + 1 : @comments.total_pages
	json.last_page @comments.total_pages

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