json.array! @authors do |a|
	json.partial! 'api/v1/authors/author', author: p[1].classify.constantize.find(p[0])
end