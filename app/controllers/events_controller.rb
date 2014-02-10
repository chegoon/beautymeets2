class EventsController < InheritedResources::Base
		  # Load authorizing from cancan
  load_and_authorize_resource

  respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  

  
  # GET /events
  # GET /events.json
  def index
    cards_per_page = 12

    if params[:tag]
      @events = Event.order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page) || Event.all 
    else
      @events = Event.order("created_at DESC").page(params[:page]).per_page(cards_per_page) || Event.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.js
    end
  end

  def show
    @event = Event.find(params[:id])

    @pictureable = @event
    @pictures = @pictureable.pictures
    @picture = Picture.new

    if (cannot? :author, @event) || (cannot? :manage, Event)
      @event.increment_view_count 
    end

		@commentable = @event
  	@comments = @commentable.root_comments.order("created_at ASC")
		
		if user_signed_in?
			@comment = Comment.build_from(@commentable, current_user.id, "") 
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

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @event.create_activity :create, owner: @event.author if (Time.zone.now >= @event.released_at)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
end
