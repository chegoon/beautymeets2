module API
	module V1
		class VideoGroupsController < API::V1::BaseController
			before_filter :set_current_user
			
			def index

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				menu = Category.where(name: params[:category], parent_id: Category.find_by_name("menu").id).first
				categories = menu ? Category.where(menu_id: menu.id) : nil
				#puts "params : #{params[:category]}"
				#puts "category : #{category}"
				# HOME 

				@video_groups = VideoGroup.where(published: true).order("created_at DESC").offset(offset).limit(limit)

			end

			def show
				@video_group = VideoGroup.find(params[:id])
				@video_group.increment_view_count 
				@posts = @video_group.videos.where(published: true).order("created_at DESC")
				#impressionist(@video_group)

			end

			private

			def set_current_user
				token = params[:authToken] 
				@user = User.find_by_authentication_token(token)
			end
		end
	end
end