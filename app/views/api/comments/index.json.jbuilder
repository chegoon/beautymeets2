if @comments.count > 0
=begin	
	json.first_page 1
	json.prev_page (@comment_page_index.to_i - 1) > 0 ? @comment_page_index.to_i - 1 : 1
	json.current_page @comment_page_index
	json.next_page (@comment_page_index.to_i + 1 <= @comments.total_pages) ? @comment_page_index.to_i + 1 : @comments.total_pages
	json.last_page @comments.total_pages
=end
	json.count @comments.count
	json.loadMore true if (@commentable.comment_threads.order("lft ASC").offset(offset+10).limit(10).count) > 0
	json.comments @comments do |comment|
		json.partial! comment
	end
end