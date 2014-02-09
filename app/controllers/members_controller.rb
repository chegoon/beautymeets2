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

  def activities
    @member = Member.find(params[:id])
    @activities = PublicActivity::Activity.where("(recipient_id = ? OR recipient_id IS NULL) AND (recipient_type = 'User' OR recipient_type IS NULL)", @member.user.id).order("created_at desc")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activities }
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
