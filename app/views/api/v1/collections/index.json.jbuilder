json.array! @collections do |col|
	json.partial! 'api/v1/collections/collection', col: col
end