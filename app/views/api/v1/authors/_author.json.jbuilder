json.id video_group.id

json.author do
	json.canShowThumb video_group.thumb_url ? true : false
	json.thumbUrl video_group.thumb_url if @video_group.thumb_url
	json.name video_group.name
end