class NoticesController < ApplicationController #InheritedResources::Base
	inherit_resources

	def index
		@commentable = Notice.last
		@comments = @commentable.root_comments.order("created_at ASC")

		if user_signed_in?
			@comment = Comment.build_from(@commentable, current_user.id, "") 
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
		@comments = @commentable.root_comments.order("created_at ASC")
		
		if user_signed_in?
			@comment = Comment.build_from(@commentable, current_user.id, "") 
			@notice.mark_as_read! :for => current_user
		else
			@comment = Comment.new
		end

		super

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