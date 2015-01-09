module API
	module V1
		class EventsController < API::V1::BaseController
			inherit_resources

			# Load authorizing from cancan
			#load_and_authorize_resource
			before_filter :set_current_user
			respond_to :json
			
			
			# GET /events
			# GET /events.json
			def index

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				cards_per_page = 12
				#@events = Event.order("created_at DESC").page(params[:page]).per_page(cards_per_page) || Event.all
				@events = Event.where('released_at <= ? AND finish_on >= ?  AND published = TRUE', Time.now, Time.now).order("created_at DESC").page(params[:page]).per_page(cards_per_page).offset(offset).limit(limit) || Event.all.offset(offset).limit(limit)
=begin
				if user_signed_in? && current_user.has_role?(:admin)
						@events = Event.order("created_at DESC").page(params[:page]).per_page(cards_per_page) || Event.all
					else
						@events = Event.where('released_at <= ? AND finish_on >= ? AND  published = TRUE', Time.now, Time.now).order("created_at DESC").page(params[:page]).per_page(cards_per_page) || Event.all
					end
				end
=end				
				respond_to do |format|
					format.html # index.html.erb
					format.json #{ render json: @events }
				end
			end

			def show
				@event = Event.find(params[:id])

				@pictureable = @event
				@pictures = @pictureable.pictures
				@picture = Picture.new
				
				#if (cannot? :author, @event) || (cannot? :manage, Event)
				if !(user_signed_in? && current_user.can_update?(@event))
					@event.increment_view_count 
				end
=begin
				@commentable = @event
				comments_per_page = 7
				if params[:page] && (params[:page] != '')
					@comment_page_index = params[:page]
				else
					#@comment_page_index = @commentable.comment_threads.order("lft ASC").paginate(:page => params[:page], :per_page => comments_per_page).total_pages
					total_results = @commentable.comments.count
					@comment_page_index = total_results / comments_per_page + (total_results % comments_per_page == 0 ? 0 : 1)
	    
				end

				#@comments = @commentable.root_comments.order("created_at ASC").page(@comment_page_index).per_page(comments_per_page)
				#@comments = @commentable.comment_threads.order("lft ASC").page(@comment_page_index).per_page(comments_per_page)
				@comments = @commentable.comment_threads.order("lft ASC").page(@comment_page_index).per_page(comments_per_page)
=end
				respond_to do |format|
					format.html # show.html.erb
					format.json #{ render json: @event }
				end
			end

			private

			def set_current_user
				token = params[:authToken] 
				@user = User.find_by_authentication_token(token)
			end
		end
	end
end