if @events
	json.array! @events do |event|
		json.partial! event
	end
end