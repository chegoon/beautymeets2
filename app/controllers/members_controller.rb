class MembersController < InheritedResources::Base
	respond_to :html, :json
	
	def update
		@member = Member.find(params[:id])
		@member.update_attributes(params[:member])
		respond_with @member
	end

	def beautyclasses
		@member = Member.find(params[:id])
		@checkouts = @member.user.checkouts.order("created_at DESC")

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @checkouts }
		end
	end

	def notifications
		@member = Member.find(params[:id])
		#@notifications = Activity.unread_by(current_user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc")
		if params[:go_prev].present?
			@activities = Activity.with_read_marks_for(current_user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc") #order("updated_at DESC")
		elsif params[:clean_history].present?
			@activities = Activity.with_read_marks_for(current_user).where("(owner_id = ? OR recipient_id = ? ) AND (recipient_type = 'User')", @member.user.id,  @member.user.id).order("created_at desc") 
			@activities.each do |a|
				a.destroy
			end
		else
			@activities = Activity.unread_by(current_user).where("(owner_id = ? OR recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id,  @member.user.id).order("created_at desc")#order("updated_at DESC")
		end   
		PublicActivity::Activity.mark_as_read! :all, :for => current_user
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @acitivities }
		end
	end

	def bookmarks
		@member = Member.find(params[:id])
		@bookmarks = @member.user.bookmarks

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @bookmarks }
		end
	end

	def tutorials
		@member = Member.find(params[:id])
		@tutorials = Tutorial.where("id NOT IN (?)", Tutorial.unread_by(@member.user).map(&:id)).order("created_at DESC")

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @tutorials }
		end
	end
end
