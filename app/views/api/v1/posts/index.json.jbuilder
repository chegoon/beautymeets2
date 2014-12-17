json.array! @posts do |p|
	json.partial! 'api/v1/posts/post', post: p[1].classify.constantize.find(p[0])
end