class VideosController < ApplicationController
	
	before_filter :authenticate_user!, except: [:index, :show]

	inherit_resources
	
	#impressionist #comment out this line when impressionist method created in each action

	# authorize controller thourgh authority
	authorize_actions_for Video, except: [:index, :show]

	private
	MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]


	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		MOBILE_BROWSERS.each do |m|
			if agent.match(m) && (agent == "android")
				#puts "android detected" 
				@android_detected = true
			end
		end
	end
	
	# GET /videos
	# GET /videos.json
	def index
		cards_per_page = 15

		if (params[:order].present?) && (params[:order] == "popular")
				if user_signed_in?
					#@videos = Video.where("published=TRUE").order("view_count DESC").unread_by(current_user).page(params[:page]).per_page(20)
					@videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
				else
					@videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
				end
		else   
				if user_signed_in?
					#@videos = Video.where("published=TRUE").order("created_at DESC").unread_by(current_user).page(params[:page]).per_page(20)
					@videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("published_at DESC").page(params[:page]).per_page(cards_per_page)
				else
					@videos = Video.joins(:video_group).where("video_groups.published=TRUE AND videos.published=TRUE").order("published_at DESC").page(params[:page]).per_page(cards_per_page)
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
			comments_per_page = 7
			page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
			@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

			if user_signed_in?
				@comment = @commentable.comments.new(user_id: current_user.id)
				@comment.build_picture 
				@video.mark_as_read! :for => current_user
			else
				@comment = Comment.new
			end

			@tutorials = Tutorial.all.last(3)

			if !(user_signed_in? && current_user.can_update?(@video))
			#if cannot? :manage, @video
				@video.increment_view_count 
				impressionist(@video) #, "", :unique => [:session_hash]) 동일 세션에서도 reload시 count
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
		@video = Video.find(params[:id])

		respond_to do |format|
			if @video.update_attributes(params[:video])
			 
				if @video.published? && PublicActivity::Activity.where(owner_id: @video.video_group.id, owner_type: "VideoGroup", trackable_id: @video.id, trackable_type: "Video").first.nil?
					@video.create_activity :create, owner: @video.video_group
				end
				format.html { redirect_to @video, notice: 'Video was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @video.errors, status: :unprocessable_entity }
			end
		end
	end
end
