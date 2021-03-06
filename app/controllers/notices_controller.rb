class NoticesController < ApplicationController #InheritedResources::Base
	inherit_resources
	authorize_actions_for Notice, except: [:index, :show]

	def index

		@commentable = Notice.find(2)
		comments_per_page = 7
		page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
		@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

		if user_signed_in?
			@comment = @commentable.comments.new(user_id: current_user.id)
			@comment.build_picture 
		else
			@comment = Comment.new
		end

		@notices = Notice.where("published = true AND id <> 2").order("created_at DESC")
		
		respond_to do |format|
			format.html 
			format.js
	    end
	end

	def show

		@notice = Notice.find(params[:id])
		@notices = Notice.all
		
		@commentable = @notice
		comments_per_page = 7
		page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
		@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

		if user_signed_in?
			@comment = @commentable.comments.new(user_id: current_user.id)
			@comment.build_picture 
		else
			@comment = Comment.new
		end


		super

	end

	# POST /tutorials
	# POST /tutorials.json
	def create
		@notice = current_user.notices.create(params[:notice])

		current_user.add_role :author, @notice

		respond_to do |format|
			if @notice.save
				format.html { redirect_to @notice, notice: 'notice was successfully created.' }
				format.json { render json: @notice, status: :created, location: @notice }
			else
				format.html { render action: "new" }
				format.json { render json: @notice.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def update
		@notice = Notice.find(params[:id])

		respond_to do |format|
			if @notice.update_attributes(params[:notice])
				#puts "p_a #{PublicActivity::Activity.where(owner_id: @tutorial.author.id, owner_type: 'User', trackable_id: @tutorial.id, trackable_type: 'Tutorial').first.present?}"
				if @notice.published? && PublicActivity::Activity.where(owner_id: current_user.id, owner_type: "User", trackable_id: @notice.id, trackable_type: "Notice").first.nil?
					@notice.create_activity :create, owner: @notice.author 
				end
				format.html { redirect_to @notice, notice: 'Notice was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @notice.errors, status: :unprocessable_entity }
			end
		end
	end
end