json.notifications @activities do |activity|
	json.author do
		json.name activity.owner.name ? activity.owner.name : activity.owner.email
		json.thumbUrl full_url(activity.owner.image_url)
	end
	json.url full_url(activity.trackable)
	json.title activity.trackable.title
	json.body activity.body
	json.cratedAt time_ago_in_words(activity.created_at)
end
