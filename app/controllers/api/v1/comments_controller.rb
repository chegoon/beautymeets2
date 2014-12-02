#encoding: utf-8
module API
	module V1
		class CommentsController < API::BaseController
			before_filter :load_commentable
			before_filter :set_current_user
			#before_filter :authenticate_user, except: [:index, :show]  
			#authorize_actions_for Comment, except: [:index, :show, :vote, :unvote]

			def index
				limit = params[:limit] || 10
				if params[:offset] && params[:offset] != ''
					offset = params[:offset]
				elsif @commentable.comments.count < limit
					offset = 0
				else
					offset = @commentable.comments.count - limit
				end
				#offset = params[:offset] || (@commentable.comments.count - limit)
				puts "offset #{offset}"

				@comments = @commentable.comment_threads.order("lft ASC").offset(offset).limit(limit)
				if offset.to_i >= limit.to_i
					@can_load_more = true if @commentable.comment_threads.order("lft ASC").offset(offset.to_i - limit.to_i).limit(limit).count > 0
				else
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
					#puts "picture: #{uploaded_file}"
					comment_params = JSON.parse(params[:comment])
					#@comment = @commentable.comments.new({user_id: @user.id, body: params[:comment][:body], picture_attributes: {picture_attributes: params[:image]}}) #picture: Picture.new(uploaded_file)})
					@comment = @commentable.comments.new({user_id: @user.id, body: comment_params['body'], picture_attributes: {image: params[:image]}}) 
					#@comment.picture.image = uploaded_file

					if @comment.save

						if params[:parent_id]
							puts "replied"
							@parent = Comment.find(params[:parent_id]) 
							@comment.move_to_child_of(@parent)
							#@comment.create_activity :create, owner: @user, recipient: @parent.author if !(@commentable.class.name == "Notice")

							if !(@commentable.class.name == "Event")
								CommentMailer.delay.parent_notification(@parent, @commentable, @comment) unless @parent.invalid?
							end
						else
							@comment.delay.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
						end

						if !(@commentable.class.name == "Event")
							CommentMailer.delay.create_notification(@commentable, @comment)
						end
						
						
						devices = Array.new
						@commentable.comments.each do |c|
							if @user.id == c.user_id
							else
								@comment.delay.create_activity :create, owner: @user, recipient: c.user
								c.user.devices.each do |d|
									devices << d.uuid
								end
							end
						end
						message = @commentable.title + "에 댓글이 달렸습니다."
						PushNotificationSender.notify_devices({content: message, device_type: 3, devices: devices})
					
						render :status => 200, :json => { :success => true, :info => "Successfully comment created"}
					
					else
						render :status => 200, :json => { :success => true, :info => "Something wrong.."}
					
						#render :new
					end
				else
					@comment = @commentable.comments.new({user_id: @user.id, body: params[:comment][:body]})

					if @comment.save

						if params[:comment][:parent_id]
							puts "replied"
							@parent = Comment.find(params[:comment][:parent_id]) 
							@comment.move_to_child_of(@parent)
							#@comment.create_activity :create, owner: @user, recipient: @parent.author if !(@commentable.class.name == "Notice")

							if !(@commentable.class.name == "Event")
								CommentMailer.delay.parent_notification(@parent, @commentable, @comment) unless @parent.invalid?
							end
						else
							@comment.delay.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
						end

						if !(@commentable.class.name == "Event")
							CommentMailer.delay.create_notification(@commentable, @comment)
						end
								
						devices = Array.new
						@commentable.comments.each do |c|
							if @user.id == c.user_id
							else
								@comment.delay.create_activity :create, owner: @user, recipient: c.user
								c.user.devices.each do |d|
									devices << d.uuid
								end
							end
						end
						message = @commentable.title + "에 댓글이 달렸습니다."
						PushNotificationSender.notify_devices({content: message, device_type: 3, devices: devices})
					
						render :status => 200, :json => { :success => true, :info => "Successfully comment created"}
					
					else
						render :status => 200, :json => { :success => true, :info => "Something wrong.."}
					
						#render :new
					end
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
				puts "user : #{@user.email}"
			end
		end
	end
end