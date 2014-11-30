if @comments.count > 0

	json.count @comments.count
	json.loadMore true if (@commentable.comment_threads.order("lft ASC").offset(offset+10).limit(10).count) > 0
	json.comments @comments do |comment|
		json.partial! comment
	end
end