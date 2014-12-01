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
				json.title activity.trackable.commentable.title
		
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
			json.thumbUrl fulll_url(activity.trackable.commentable.thumbnail.image_url(:small)) if activity.trackable.commentable.thumbnail.present?
		
		else
			json.title activity.trackable.title

			if activity.trackable.class.to_s == "Board"
				json.url "#/app/boards/" + activity.trackable.id 
			else
				json.url "#/app/posts/" + activity.trackable.id.to_s + "?postType=" + activity.trackable.class.to_s
			end
			
			json.body activity.trackable.description
			json.thumbUrl fulll_url(activity.trackable.thumbnail.image_url(:small)) if activity.trackable.thumbnail.present?
		end
		
		json.cratedAt time_ago_in_words(activity.created_at)
	end
end