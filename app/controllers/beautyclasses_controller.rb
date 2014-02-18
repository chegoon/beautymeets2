class BeautyclassesController <  ApplicationController
	inherit_resources

  # Load authorizing from cancan
  #load_and_authorize_resource
  
  # authorize controller thourgh authority
  authorize_actions_for Beautyclass, except: [:index, :show]

  respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  
  
  autocomplete :location, :name

	def index
		if params[:cat].present?
			if user_signed_in? && current_user.can_update?(Beautyclass)
				@beautyclasses = Beautyclass.where("id IN (?)", Beautyclass.joins(:categories).where("category_id = ?", params[:cat]).map(&:id)).order("created_at DESC")
			else
				@beautyclasses = Beautyclass.where("published = true AND id IN (?)",  Beautyclass.joins(:categories).where("category_id = ?", params[:cat]).map(&:id)).order("created_at DESC")
			end
		else
			@beautyclasses = Beautyclass.where("published = ? AND closed = ? ", ((params[:published] ? params[:published] : true ) || false), ((params[:closed] ? params[:closed] : false) || false)).order("created_at DESC")
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @beautyclasses }
		end
	end

  def show
    @beautyclass = Beautyclass.find(params[:id])
    @location = @beautyclass.location 

    @pictureable = @beautyclass
    @pictures = @pictureable.pictures
    @picture = Picture.new

    #if (cannot? :author, @beautyclass) || (cannot? :manage, Beautyclass)
    if user_signed_in? && !current_user.can_update?(@beautyclass)
      @beautyclass.increment_view_count 
    end

		@commentable = @beautyclass
  	@comments = @commentable.root_comments.order("created_at ASC")
		
		if user_signed_in?
      @beautyclass.mark_as_read! :for => current_user
			@comment = Comment.build_from(@commentable, current_user.id, "") 
			
			if current_user.checkouts.present?
				# 프라이빗 클래스는 다시 신청할 수 있으므로 쿼리 조건 변경
				#@checkout = current_user.checkouts.find_by_beautyclass_id(@beautyclass.id)
				@checkouts = current_user.checkouts.where(beautyclass_id: @beautyclass.id)
			end
		else
			@comment = Comment.new
		end

		@hash = Gmaps4rails.build_markers(@beautyclass.location) do |location, marker|
		  marker.lat location.latitude
		  marker.lng location.longitude		  
		end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beautyclass }
    end
  end

  def edit
    @beautyclass = Beautyclass.find(params[:id])
    @location = @beautyclass.location 

  end

  # POST /tutorials
	# POST /tutorials.json
	def create
		@beautyclass = current_user.beautyclasses.create(params[:beautyclass])
    current_user.add_role :author, @beautyclass

		respond_to do |format|
			if @beautyclass.save
				format.html { redirect_to @beautyclass, notice: 'Beautyclass was successfully created.' }
				format.json { render json: @beautyclass, status: :created, location: @beautyclass }
			else
				format.html { render action: "new" }
				format.json { render json: @beautyclass.errors, status: :unprocessable_entity }
			end
		end
	end

=begin
  def update
    super
    @beautyclass.create_activity :create, owner: @beautyclass.author if @beautyclass.published? && PublicActivity::Activity.where(owner_id: @beautyclass.author.id, owner_type: "User", trackable_id: @beautyclass.id, trackable_type: "Beautyclass").nil?
  end
=end

	def entry_code_check
		@beautyclass = Beautyclass.find(params[:id])
    		#puts "@beauclass.entry_code #{@beauclass.entry_code}"
			#puts "params[:entry_code] #{params[:beauclass][:entry_code]}"

    	if @beautyclass.category_class_id == "special" 
    		if params[:beautyclass][:entry_code] == @beauclass.entry_code
    			redirect_to :action => :show, :flash => {:entry_code => params[:beautyclass][:entry_code]}
    		else
				redirect_to :back, notice: 'The entry code was wrong, Try again'
    		end
    	else
    		redirect_to :action => :show
		end
	end

end