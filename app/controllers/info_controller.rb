class InfoController < ApplicationController
  def about
  end

  def privacy
  end

  def terms
  end
  def tag
  	if params[:tag]
  		#@beautorials = Beautorial.all.tagged_with(params[:tag])
  		#@beauclasses = Beauclass.all.tagged_with(params[:tag])
  		@videos = Video.where("published=TRUE").order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(20)
      @tutorials = Tutorial.where("published=TRUE").order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(20)
  	else
  	end
  end
end
