class EventsController < ApplicationController
	inherit_resources

	# Load authorizing from cancan
	#load_and_authorize_resource

	# authorize controller thourgh authority
	authorize_actions_for Beautyclass, except: [:index, :show]

	respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  



	# GET /events
	# GET /events.json
	def index
		cards_per_page = 12

		if params[:tag]
			if user_signed_in? && current_user.has_role?(:admin)
				@events = Event.order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page) || Event.all 
			else
				@events = Event.where('released_at <= ? AND finish_on >= ?  AND published = TRUE', Time.now, Time.now).order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page) || Event.all 
			end
		else
			if user_signed_in? && current_user.has_role?(:admin)
				@events = Event.order("created_at DESC").page(params[:page]).per_page(cards_per_page) || Event.all
			else
				@events = Event.where('released_at <= ? AND finish_on >= ? AND  published = TRUE', Time.now, Time.now).order("created_at DESC").page(params[:page]).per_page(cards_per_page) || Event.all
			end
		end
		
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @events }
		end
	end

	def show
		@event = Event.find(params[:id])

		@pictureable = @event
		@pictures = @pictureable.pictures
		@picture = Picture.new

		@tutorials = Tutorial.where(published: true).order("view_count DESC").sample(5).first(3)
		
		#if (cannot? :author, @event) || (cannot? :manage, Event)
		if !(user_signed_in? && current_user.can_update?(@event))
			@event.increment_view_count 
		end

		@commentable = @event
		#@comments = @commentable.root_comments.order("created_at ASC")
		comments_per_page = 7
		page_index = params[:page] ? params[:page] : @commentable.root_comments.order("created_at ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
		@comments = @commentable.root_comments.order("created_at ASC").page(page_index).per_page(comments_per_page)

		if user_signed_in?
			#@comment = Comment.build_from(@commentable, current_user.id, "") 
			@comment = @commentable.comments.new(user_id: current_user.id)
			@event.mark_as_read! :for => current_user
		else
			@comment = Comment.new
		end

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @event }
		end
	end

	# POST /events
	# POST /events.json
	def create
		@event = current_user.events.create(params[:event])
		current_user.add_role :author, @event
		#@event = Beautorial.new(params[:event])

		respond_to do |format|
			if @event.save
				format.html { redirect_to @event, notice: 'Event was successfully created.' }
				format.json { render json: @event, status: :created, location: @event }
			else
				format.html { render action: "new" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@event = Event.find(params[:id])
		@event.picture_id = params[:th_to_desktop] if params[:th_to_desktop].present?
		@event.mobile_picture_id = params[:th_to_mobile] if params[:th_to_mobile].present?
		@event.save
		puts "th_to_desktop info : #{params[:th_to_desktop]}"
		puts "th_to_mobile info : #{params[:th_to_mobile]}"

		respond_to do |format|
			if @event.update_attributes(params[:event])
				@event.create_activity :create, owner: @event.host if (Time.zone.now >= @event.released_at) && PublicActivity::Activity.where(owner_id: current_user.id, owner_type: "User", trackable_id: @event.id, trackable_type: "Event").nil?
				format.html { redirect_to @event, notice: 'Event was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
	end
end
