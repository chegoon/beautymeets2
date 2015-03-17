#encoding: utf-8
module API
	module V1
		class CommentsController < API::V1::BaseController
			before_filter :load_commentable
			before_filter :set_current_user
			#before_filter :authenticate_user, except: [:index, :show]  
			#authorize_actions_for Comment, except: [:index, :show, :vote, :unvote]

			def index
				limit = (params[:limit] && params[:limit] != '') ? params[:limit].to_i : 10
				if params[:offset] && params[:offset] != '' && params[:offset].to_i > 0
					offset = params[:offset].to_i
				elsif (@commentable.comments.count < limit) || (params[:offset].to_i < 0)
					offset = 0
				else
					offset = @commentable.comments.count - limit
				end
				#offset = params[:offset] || (@commentable.comments.count - limit)
				puts "limit : #{limit}"
				puts "offset : #{offset}"
				if offset > 0
					@can_load_more = true 
					@comments = @commentable.comment_threads.order("lft ASC").offset(offset).limit(limit)
				# 이전 댓글 보기의 마지막 페이지	
				elsif offset == 0
					surplus_limit = @commentable.comments.count % limit
					# 댓글이 10개일 경우
					if surplus_limit == 0
						@comments = @commentable.comment_threads.order("lft ASC").offset(offset).limit(limit)
					else
						@comments = @commentable.comment_threads.order("lft ASC").offset(offset).limit(surplus_limit)
					end
					@can_load_more = false
					
				# 댓글이 limit 보다 작을 경우
				else
					@comments = @commentable.comments
					@can_load_more = false
				end

			end

			def new
				@comment = @commentable.comments.new
			end

			def show
				@comment = Comment.find(params[:id])
				render json: @comment
			end

			def create    
				if params[:image]
					if params[:comment] # android 
						comment_params = JSON.parse(params[:comment].to_json)
						@comment = @commentable.comments.new({user_id: @user.id, body: comment_params['body'], picture_attributes: {image: params[:image]}}) 
						@parent = Comment.find(comment_params['parent_id']) if comment_params['parent_id']
					else
						@comment = @commentable.comments.new({user_id: @user.id, body: JSON.parse(params[:body].to_json)['body'], picture_attributes: {image: params[:image]}}) 
						@parent = Comment.find(JSON.parse(params[:parent_id].to_json)['parent_id']) if params[:parent_id]
					end
				else
					@comment = @commentable.comments.new({user_id: @user.id, body: params[:comment][:body]})
					@parent = Comment.find(params[:comment][:parent_id]) if params[:comment][:parent_id]
				end

				if @comment.save
					if @parent
						@comment.move_to_child_of(@parent)
						@comment.delay.create_activity :create, owner: @user, recipient: @parent.user if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event") && (@parent.user) && (@user != @parent.user) && PublicActivity::Activity.where(owner_id: @user.id, owner_type: "User", trackable_id: @comment.id, trackable_type: "Comment", recipient_id: @parent.user.id, recipient_type: "User").first.nil?
						CommentMailer.delay.parent_notification(@parent, @commentable, @comment) unless @parent.invalid?
					else
						@comment.delay.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event") && (@user != @commentable.author)
					end

					if !((@commentable.class.name == "Event") || (@commentable.class.name == "Notice"))
						# mail to beautymeets team
						CommentMailer.delay.create_notification(@commentable, @comment)

						devices = Array.new
						@commentable.comments.each do |c|
							if @user.id == c.user_id
							else
								# notify to all comment authors 
								@comment.delay.create_activity :create, owner: @user, recipient: c.user if c.user && !Activity.where(owner_id: @user.id, owner_type: "User", trackable_id: @comment.id, trackable_type: "Comment", recipient_id: c.user.id, recipient_type: "User")
								if c.user && (c.user.get_push_notifications == true ) && c.user.devices
									c.user.devices.each do |d|
										devices << d.uuid
									end
								end
							end
						end
						message = @commentable.title + "에 댓글이 달렸습니다."
						if (@commentable.class.name.to_s.pluralize.downcase == "tutorials") || (@commentable.class.name.to_s.pluralize.downcase == "posts") || (@commentable.class.name.to_s.pluralize.downcase == "videos") || (@commentable.class.name.to_s.pluralize.downcase == "items")
							posts = "posts"
						else
							posts = @commentable.class.name.to_s.pluralize.downcase
						end
						PushNotificationSender.delay.notify_devices({content: message, devices: devices, data:{ url: "#/app/#{posts}/#{@commentable.id}?postType=#{@commentable.class.name}" }})	
				
					end
					
					render :status => 200, :json => { :success => true, :info => "Successfully comment created"}
				
				else
					render :status => 200, :json => { :success => true, :info => "Something wrong.."}
				
					#render :new
				end
			end

			def destroy
				@comment = @commentable.comments.find(params[:id])

				@comment.destroy

				respond_to do |format|
					format.html { redirect_to @commentable, notice: "Comment destroied"  }
					format.js
					format.json { head :no_content }
				end
			end

			def vote
				@comment = @commentable.comments.find(params[:id])
				#authorize_action_for @comment

				@comment.liked_by @user

				respond_to do |format|
					format.html { redirect_to @commentable, notice: "Comment voted"  }
					#format.json { head :no_content }
					format.json { render @comment }
				end
			end

			def unvote
				@comment = @commentable.comments.find(params[:id])
				#authorize_action_for @comment
				
				@comment.unliked_by @user
				respond_to do |format|
					format.html { redirect_to @commentable, notice: "Comment unvoted"  }
					format.json { render @comment }
				end
			end

			private

			def load_commentable
				id = request.path.split('/')[4]
				resource = params[:postType] 
				@commentable = (resource.singularize + "s").classify.constantize.find(id)
			end

			def set_current_user
				token = params[:authToken] 
				puts "token : #{token}"
				@user = User.find_by_authentication_token(token)
			end
		end
	end
end