module API
	module V1
		class UsersController < API::V1::BaseController
			before_filter :load_resource_through_auth_token, only: [:index, :notifications, :favorites, :update]
			
			# me : mypage
			def index
				#redirect_to api_user_url(@user)
				@member = @user.profile
				#@notifications = Activity.unread_by(@user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc") if @user.has_role?(:member)
				#@notifications = Activity.unread_by(@user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @user.id,  @user.id).order("created_at desc")#order("updated_at DESC")
				#@notifications = Activity.with_read_marks_for(@user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc") #order("updated_at DESC")
				@notifications = Activity.unread_by(@user).where("(recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)",  @user.id).order("created_at desc")
			end

			def show
				@user = User.find(params[:id])
				@member = @user.profile
				#@member = @user.profile
				#render json: @user
			end

			def notifications

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				#@user = User.find(params[:id])
				@member = @user.profile
				#@notifications = Activity.unread_by(current_user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc")
				#@activities = Activity.with_read_marks_for(@user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc") #order("updated_at DESC")
				#@activities = Activity.with_read_marks_for(@user).where("(recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)",  @member.user.id).order("created_at desc") #order("updated_at DESC")

				if params[:seeAll] && (params[:seeAll] == 'true')
					#@activities = Activity.with_read_marks_for(@user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc") #order("updated_at DESC")
					@activities = Activity.with_read_marks_for(@user).where("(recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)",  @member.user.id).order("created_at desc").offset(offset).limit(limit) #order("updated_at DESC")
				else
					#@activities = Activity.unread_by(@user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @user.id,  @user.id).order("created_at desc")#order("updated_at DESC")
					@activities = Activity.unread_by(@user).where("(recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)",  @user.id).order("created_at desc").offset(offset).limit(limit)#order("updated_at DESC")
					PublicActivity::Activity.mark_as_read! :all, :for => @user
				end   

				#render json: @activities.sort_by{|e| e[:created_at]}.reverse
			end

			def favorites
				@user = User.find(params[:id])
				@favorites = Bookmark.where(user_id: @user.id).order("created_at DESC") #@user.bookmarks
				#render json: @favorites.sort_by{|e| e[:created_at]}.reverse
			end

			def update
				#@user = User.find(params[:id])
				@member = @user.profile
				push_noti = (params[:user][:getPushNotifications] && (params[:user][:getPushNotifications] == 'true')) ? 1 : 0

				if @user.update_attributes(username: params[:user][:name], password: params[:user][:password], get_push_notifications: params[:user][:getPushNotifications])
					respond_to do |format|
						format.json {render json: {status: 200, success: true, info: "User info Updated successfully." }}
					end
				else
				end
			end

			protected
			def load_resource_through_auth_token
				@user = User.find_for_database_authentication(authentication_token: params[:authToken])
				#@user = User.find_by_authenticating_token(params[:auth_token])
			end
		end
	end
end
