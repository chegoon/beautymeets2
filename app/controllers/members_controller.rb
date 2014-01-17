class MembersController < InheritedResources::Base
  respond_to :html, :json

  def update
    @member = Member.find(params[:id])
    @member.update_attributes(params[:member])
    respond_with @member
  end

  def beautyclasses
  	@member = Member.find(params[:id])

		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end

  end

  def tutorials
  	@member = Member.find(params[:id])

		respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @member }
    end
  end
end
