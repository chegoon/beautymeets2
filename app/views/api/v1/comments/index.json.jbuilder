if @comments.count > 0

	json.count @comments.count
	json.canLoadMore true if @can_load_more? && @can_load_more == true
	json.comments @comments do |comment|
		json.partial! comment
	end
end