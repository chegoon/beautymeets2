json.notifications @activities do |activity|
	if activity.trackable
		
		json.author do
			if activity.owner
				json.name activity.owner.name ? activity.owner.name : activity.owner.email
				json.thumbUrl full_url(activity.owner.image_url(:small)) if activity.owner.image?
			else
				json.name ""
			end
		end
		#/posts/:id?postType
		#json.url full_url(url_for(activity.trackable))
		
		if activity.trackable.class.to_s == "Comment"

			if ActiveRecord::Base.connection.column_exists?(activity.trackable.commentable_type.downcase.pluralize, :title)
				json.title activity.trackable.commentable.try(:title)
		
				if activity.trackable.commentable.class.to_s == "Board"
					json.url "#/app/boards/" + activity.trackable.commentable.id.to_s
				else
					json.url "#/app/posts/" + activity.trackable.commentable.id.to_s + "?postType=" + activity.trackable.commentable.class.to_s
				end
		
			# else-case : item
			else
				json.url "#/app/posts/" + activity.trackable.commentable.id.to_s + "?postType=" + activity.trackable.commentable.class.to_s
				json.title activity.trackable.commentable.name
			end

			json.body activity.trackable.body
			if activity.trackable.commentable.class.to_s == "Board"
				json.thumbUrl full_url(activity.trackable.commentable.picture.image_url(:small)) if activity.trackable.commentable.picture.present?
			elsif activity.trackable.commentable.class.to_s == "Video"
				json.thumbUrl activity.trackable.commentable.thumb_url if activity.trackable.commentable.thumb_url.present?
			else
				json.thumbUrl full_url(activity.trackable.commentable.thumbnail.image_url(:small)) if activity.trackable.commentable.thumbnail.present?
			end
		
		else
			json.title activity.trackable.title

			if activity.trackable.class.to_s == "Board"
				json.url "#/app/boards/" + activity.trackable.id 
			elsif activity.trackable.class.to_s == "Notice"
				json.url "#/app/notices/" + activity.trackable.id.to_s
			else
				json.url "#/app/posts/" + activity.trackable.id.to_s + "?postType=" + activity.trackable.class.to_s
			end
			
			json.body activity.trackable.description

			if activity.trackable.class.to_s == "Board"
				json.thumbUrl full_url(activity.trackable.picture.image_url(:small)) if activity.trackable.picture.present?
			elsif activity.trackable.class.to_s == "Video"
				json.thumbUrl activity.trackable.thumb_url if activity.trackable.thumb_url.present?
			elsif activity.trackable.class.to_s == "Notice"
				json.thumbUrl full_url(activity.owner.image_url(:small)) if activity.owner.image?
			else
				json.thumbUrl full_url(activity.trackable.thumbnail.image_url(:small)) if activity.trackable.thumbnail.present?
			end
		end
		
		json.createdAt time_ago_in_words(activity.created_at)
	end
end