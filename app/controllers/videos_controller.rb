class VideosController < ApplicationController
	
  before_filter :authenticate_user!, except: [:index, :show]

  inherit_resources
  
  #impressionist #comment out this line when impressionist method created in each action

  # authorize controller thourgh authority
  authorize_actions_for Video, except: [:index, :show]
  
  # GET /videos
  # GET /videos.json
  def index
    if (params[:order].present?) && (params[:order] == "popular")
        if user_signed_in?
          #@videos = Video.where("published=TRUE").order("view_count DESC").unread_by(current_user).page(params[:page]).per_page(20)
          @videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("view_count DESC").page(params[:page]).per_page(20)
        else
          @videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("view_count DESC").page(params[:page]).per_page(20)
        end
    else   
        if user_signed_in?
          #@videos = Video.where("published=TRUE").order("created_at DESC").unread_by(current_user).page(params[:page]).per_page(20)
          @videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("published_at DESC").page(params[:page]).per_page(20)
        else
          @videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("published_at DESC").page(params[:page]).per_page(20)
        end
    end
    
    
    
    @head_video = @videos.sample(1).first
    @categories = Video.joins(:categories).where("parent_id IS NULL ").all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
      format.js
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])
    
    #@video_recs = Video.joins(:video_categories).where("published=TRUE AND video_categories.id IN (?) AND videos.id != ?", @video.video_categories.map(&:id), @video.id).order("view_count DESC LIMIT 50").sample(3)
    if @video.video_group.published || (user_signed_in? && current_user.can_update?(@video))

      @commentable = @video
      @comments = @commentable.root_comments.order("created_at ASC")
      
      @tutorials = Tutorial.all.last(3)

      if user_signed_in?
        @comment = Comment.build_from(@commentable, current_user.id, "") 
        @video.mark_as_read! :for => current_user
      else
        @comment = Comment.new
      end

      if !(user_signed_in? && current_user.can_update?(@video))
      #if cannot? :manage, @video
        @video.increment_view_count 
        impressionist(@video, "", :unique => [:session_hash])
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @video }
      end
    else
      redirect_to videos_path
    end
  end

  def update
    #if @video.published? && PublicActivity::Activity.where(owner_id: current_user.id, owner_type: "User", trackable_id: @video.id, trackable_type: "Video").first.nil?
    #  @video.create_activity :create, owner: current_user 
    #end
    super
    #@video.create_activity :create if @video.published? && PublicActivity::Activity.where(trackable_id: @video.id, trackable_type: "Video").nil?
  end
end
