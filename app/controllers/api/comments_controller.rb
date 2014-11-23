module API
	class CommentsController < API::BaseController
		before_filter :load_commentable
		before_filter :set_current_user
		#before_filter :authenticate_user, except: [:index, :show]  
		#authorize_actions_for Comment, except: [:index, :show, :vote, :unvote]

		def index

			comments_per_page = 7
			@comment_page_index = params[:commentPage] ? params[:commentPage] : @commentable.comment_threads.order("lft ASC").paginate(:page => params[:commentPage], :per_page => comments_per_page).total_pages
			#@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)
			@comments = @commentable.comment_threads.order("lft ASC").page(@comment_page_index).per_page(comments_per_page)

		end

		def new
			@comment = @commentable.comments.new
		end

		def show
			@comment = Comment.find(params[:id])
			render json: @comment
		end

		def parse_image_data(base64_image)
			filename = "upload-image"
			in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]
	 
			@tempfile = Tempfile.new(filename)
			@tempfile.binmode
			@tempfile.write Base64.decode64(string)
			@tempfile.rewind
	 
			# for security we want the actual content type, not just what was passed in
			content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]
	 
			# we will also add the extension ourselves based on the above
			# if it's not gif/jpeg/png, it will fail the validation in the upload model
			extension = content_type.match(/gif|jpeg|png/).to_s
			filename += ".#{extension}" if extension
	 
			ActionDispatch::Http::UploadedFile.new({
				tempfile: @tempfile,
				content_type: content_type,
				filename: filename
			})
		end

		def clean_tempfile
			if @tempfile
				@tempfile.close
				@tempfile.unlink
			end
		end

		def create    
			#the_params = params.require(:comment).permit(:image)
			#uploaded_file = parse_image_data(params[:image]) if params[:image]

			#@comment = Comment.build_from(@commentable, @user.id)
			
			puts "user_id: #{@user.id}, "
			puts "comment: #{params}, "
			#the_params = ActiveSupport::JSON.decode(params) if params
			if params[:image]
				#puts "picture: #{uploaded_file}"

				#@comment = @commentable.comments.new({user_id: @user.id, body: params[:comment][:body], picture_attributes: {picture_attributes: params[:image]}}) #picture: Picture.new(uploaded_file)})
				@comment = @commentable.comments.new({user_id: @user.id, body: params[:body], picture_attributes: {image: params[:image]}}) 
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
						@comment.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
					end

					if !(@commentable.class.name == "Event")
						CommentMailer.delay.create_notification(@commentable, @comment)
					end
					
					
					devices = Array.new
					@commentable.comments.each do |c|
						if @user.id == c.user_id
						else
							@comment.create_activity :create, owner: @user, recipient: c.user
							c.user.devices.each do |d|
								devices << d.uuid
							end
						end
					end
					#message_title = @commentable.title + "에 댓글이 달렸습니다."
					#PushNotificationSender.notify_devices({message: message_title, device_type: 3, devices: {devices}}
				
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
						@comment.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
					end

					if !(@commentable.class.name == "Event")
						CommentMailer.delay.create_notification(@commentable, @comment)
					end
							
					devices = Array.new
					@commentable.comments.each do |c|
						if @user.id <> c.user_id
							@comment.create_activity :create, owner: @user, recipient: c.user
							c.user.devices.each do |d|
								devices << d.uuid
							end
						end
					end
					PushNotificationSender.notify_devices({message: @commentable.title + "에 댓글이 달렸습니다.", device_type: 3, devices: {devices}}
				
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
			id = request.path.split('/')[3]
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