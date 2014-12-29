json.array! @collections do |collection|
	json.partial! 'api/v1/collections/collection', collection: collection
end