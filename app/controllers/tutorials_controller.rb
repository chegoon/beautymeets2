class TutorialsController < ApplicationController
  inherit_resources

  # Load authorizing from cancan
  # load_and_authorize_resource

  # authorize controller thourgh authority
  authorize_actions_for Tutorial, except: [:index, :show]

  respond_to :html, :json
	before_filter :authenticate_user!, except: [:index, :show]  

  autocomplete :item, :name
  
  # GET /tutorials
  # GET /tutorials.json
  def index
    cards_per_page = 12

    if (params[:cond].present?) && (params[:cond] == "uncategorized")
        #tutorials_categorized = Tutorial.where("id NOT in (?)", TutorialCategory.select("id")  )
        #tutorial_categorized_ids = Tutorial.joins(:tutorial_categorizations)
        #@tutorials = Tutorial.joins(:tutorial_categories).where("tutorials.id NOT in (?)", tutorial_categorized_ids.map(&:id)).page(params[:page]).per_page(10)
      if params[:tag]
        @tutorials = Tutorial.where("id NOT in (?) and published=TRUE", Tutorial.joins(:categories).map(&:id)).tagged_with(params[:tag]).order("creatd_at DESC").page(params[:page]).per_page(cards_per_page)
      else
        @tutorials = Tutorial.where("id NOT in (?) and published=TRUE", Tutorial.joins(:categories).map(&:id)).order("creatd_at DESC").page(params[:page]).per_page(cards_per_page)
      end        

    elsif (params[:order].present?) && (params[:order] == "popular")
      if params[:tag]
        @tutorials = Tutorial.where("published=TRUE").order("view_count DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page)
      else
        @tutorials = Tutorial.where("published=TRUE").order("view_count DESC").page(params[:page]).per_page(cards_per_page)
      end
    else      
      if params[:tag]
        @tutorials = Tutorial.where("published=TRUE").order("created_at DESC").tagged_with(params[:tag]).page(params[:page]).per_page(cards_per_page)
      else
        @tutorials = Tutorial.where("published=TRUE").order("created_at DESC").page(params[:page]).per_page(cards_per_page)
      end
    end
    @categories = Tutorial.joins(:categories).where("parent_id IS NULL ").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tutorials }
      format.js
    end
  end

  def show
    @tutorial = Tutorial.find(params[:id])

    @pictureable = @tutorial
    @pictures = @pictureable.pictures
    @picture = Picture.new

    @itemizable = @tutorial
    @items = @itemizable.items
    @item = Item.new

    @tutorials = Tutorial.where("id != ? AND published=TRUE", @tutorial.id).order("created_at DESC").limit(3)
    @videos = Video.where(published: true).order("created_at DESC").limit(4)

    #if (cannot? :author, @tutorial) || (cannot? :manage, Tutorial)
    if user_signed_in? && !current_user.can_update?(@tutorial)
      @tutorial.increment_view_count 
    end

		@commentable = @tutorial
  	@comments = @commentable.root_comments.order("created_at ASC")
		
		if user_signed_in?
			@comment = Comment.build_from(@commentable, current_user.id, "") 
      @tutorial.mark_as_read! :for => current_user
		else
			@comment = Comment.new
		end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tutorial }
    end
  end

  # POST /tutorials
	# POST /tutorials.json
	def create
		@tutorial = current_user.tutorials.create(params[:tutorial])
    current_user.add_role :author, @tutorial
		#@tutorial = Beautorial.new(params[:tutorial])

		respond_to do |format|
			if @tutorial.save
				format.html { redirect_to @tutorial, notice: 'Tutorial was successfully created.' }
				format.json { render json: @tutorial, status: :created, location: @tutorial }
			else
				format.html { render action: "new" }
				format.json { render json: @tutorial.errors, status: :unprocessable_entity }
			end
		end
	end

  def update
    @tutorial = Tutorial.find(params[:id])

    respond_to do |format|
      if @tutorial.update_attributes(params[:tutorial])
        if @tutorial.published? && PublicActivity::Activity.where(owner_id: @tutorial.author.id, owner_type: "User", trackable_id: @tutorial.id, trackable_type: "Tutorial").nil?
          @tutorial.create_activity :create, owner: @tutorial.author 
        end
        format.html { redirect_to @tutorial, notice: 'Tutorial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tutorial.errors, status: :unprocessable_entity }
      end
    end
  end
end
