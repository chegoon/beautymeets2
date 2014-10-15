module API
	class CommentsController < API::BaseController
		before_filter :load_commentable
		before_filter :set_current_user, except: [:index, :show]  
		#before_filter :authenticate_user, except: [:index, :show]  
		#authorize_actions_for Comment, except: [:index, :show, :vote, :unvote]

		def index
			comments_per_page = 10
			#@comments = @commentable.comments.where("parent_id IS NULL").order("created_at ASC").page(params[:page]).per_page(comments_per_page)
			@comments = @commentable.comments
			#render json: @comments
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
			
			if params[:image]
				puts "user_id: #{@user.id}, "
				puts "comment: #{params}, "
				#puts "picture: #{uploaded_file}"

				#@comment = @commentable.comments.new({user_id: @user.id, body: params[:comment][:body], picture_attributes: {picture_attributes: params[:image]}}) #picture: Picture.new(uploaded_file)})
				@comment = @commentable.comments.new({user_id: @user.id, body: "kk", picture_attributes: {picture_attributes: params[:image]}}) 
				#@comment.picture.image = uploaded_file
			else
				@comment = @commentable.comments.new({user_id: @user.id, body: params[:comment][:body]})
			end

			if @comment.save
				puts "comment : #{@comment}"

				if params[:comment][:parent_id]
					@parent = Comment.find(params[:comment][:parent_id]) 
					if !(@commentable.class.name == "Event")
						CommentMailer.delay.parent_notification(@parent, @commentable, @comment) unless @parent.invalid?
					end
				end

				if !(@commentable.class.name == "Event")
					CommentMailer.delay.create_notification(@commentable, @comment)
				end
				#@comment.create_activity :create, owner: @user, recipient: @commentable.author
			
				if @parent
					@comment.move_to_child_of(@parent)
					@comment.create_activity :create, owner: @user, recipient: @parent.author if !(@commentable.class.name == "Notice")
				else
					@comment.create_activity :create, owner: @user, recipient: @commentable.author if !(@commentable.class.name == "Notice") && !(@commentable.class.name == "Event")
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
			authorize_action_for @comment

			@comment.liked_by @user

			respond_to do |format|
				format.html { redirect_to @commentable, notice: "Comment voted"  }
				format.js
				format.json { head :no_content }
			end
		end

		def unvote
			@comment = @commentable.comments.find(params[:id])
			authorize_action_for @comment
			
			@comment.unliked_by @user
			respond_to do |format|
				format.html { redirect_to @commentable, notice: "Comment unvoted"  }
				format.js
				format.json { head :no_content }
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
			@user = User.find_by_authentication_token(token)
		end
	end
end