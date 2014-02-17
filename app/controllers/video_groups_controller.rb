
class VideoGroupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  # authorize controller thourgh authority
  authorize_actions_for VideoGroup, except: [:index, :show]
  authority_action :update_groups => "update"
  
  def resource_name 
    :user 
  end 

  def resource 
    @resource ||= User.new 
  end 

  def devise_mapping 
    @devise_mapping ||= Devise.mappings[:user] 
  end 

  def resource_class 
    User 
  end

  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  # GET /video_groups
  # GET /video_groups.json
  def index
    @video_groups = VideoGroup.order("name ASC").all
    @categories = Category.where("parent_id IS NULL ").all
    @videos = Video.where("published=TRUE").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @video_groups }
    end
  end

  # GET /video_groups/1
  # GET /video_groups/1.json
  def show
    @video_group = VideoGroup.find(params[:id])
    @video = @video_group.videos.where('published=TRUE').order("view_count DESC").limit(20).sample(1).first

    if (params[:order].present?) && (params[:order] == "popular")
      @videos = @video_group.videos.where("published=TRUE").order("view_count DESC").page(params[:page]).per_page(20)
    else
      @videos = @video_group.videos.where("published=TRUE").order("created_at DESC").page(params[:page]).per_page(20)
    end
    @categories = Category.where("parent_id IS NULL ").all
    #@categories = Category.joins(:videos).where("videos.id in (?)", @videos.map(&:id))
=begin
    if !(user_signed_in? && (current_user.has_role? :admin))
      @video_group.increment_view_count
    end
=end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video_group }
    end
  end

  # GET /video_groups/new
  # GET /video_groups/new.json
  def new
    @video_group = VideoGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video_group }
    end
  end

  # GET /video_groups/1/edit
  def edit
    @video_group = VideoGroup.find(params[:id])
  end

  # POST /video_groups
  # POST /video_groups.json
  def create
    @video_group = VideoGroup.find_or_create_by_youtube_id(params[:video_group][:youtube_id])
    VideoGroup.delay.update_group(@video_group.id)

    respond_to do |format|
      if @video_group.save

        format.html { redirect_to video_groups_path, notice: 'Video group was successfully created.' }
        format.json { render json: @video_group, status: :created, location: @video_group }

      else
        format.html { render action: "new" }
        format.json { render json: @video_group.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /video_groups/1
  # PUT /video_groups/1.json
  def update
    @video_group = VideoGroup.find(params[:id])

    respond_to do |format|
      if @video_group.update_attributes(params[:video_group])
        format.html { redirect_to @video_group, notice: 'Video group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_groups
    @video_groups = VideoGroup.all

    @video_groups.each do |group|
      #VideoGroup.delay.update_group(group.id)
      VideoGroup.update_group(group.id)
    end

    redirect_to video_groups_path

  end

  # DELETE /video_groups/1
  # DELETE /video_groups/1.json
  def destroy
    @video_group = VideoGroup.find(params[:id])
    @video_group.destroy

    respond_to do |format|
      format.html { redirect_to video_groups_url }
      format.json { head :no_content }
    end
  end


  private
  
end