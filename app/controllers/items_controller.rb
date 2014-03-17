class ItemsController < ApplicationController
  inherit_resources

  # impressionist #comment out this line when impressionist method created in each action

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :load_itemizable, except: [:index, :new, :create, :autocomplete_brand_name]
  
  autocomplete :brand, :name
	
  # GET /items/1
  # GET /items/1.json
  def index
    if @itemizable.present?
      @items = @itemizable.items
    else
      if user_signed_in? && current_user.has_update?(Item)
        @items = Item.order("view_count DESC")
      else
        @items = Item.where("id IN (?)", Itemization.pluck(:item_id)).order("view_count DESC")
      end
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end

  end

  def new
    if @itemizable.present?
      @item = @itemizable.items.new
    else
      @item = Item.new
    end    
  end
  
  def create
    #new & save시에는 itemization 이 creation되지 않
    #@item = @itemizable.items.new(params[:item])

    # 아래는 find_or_create_by 메소드를 구현한 것, 현재는 model에서 동작함
=begin
    @item = Item.find_by_name(params[:item][:name])
    if @item.present? 
      itemization = @itemizable.itemizations.find_by_item_id(@item.id) || @itemizable.itemizations.create(item_id: @item.id) 
    else
      @item = @itemizable.items.create(params[:item])
    end
=end
    @item = Item.new(params[:item])
    if @item.save
      if @itemizable
        redirect_to @itemizable, notice: "Item created."
      else
        redirect_to @item, notice: "Item created."
      end
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    impressionist(@item, "", :unique => [:session_hash])

    @tutorials = @item.tutorials
    @videos = @item.videos

    @pictureable = @item
    @pictures = @pictureable.pictures
    @picture = Picture.new
    
    @items = @tutorials.order("view_count DESC").first.items.where("item_id <> ?", @item.id).order("view_count DESC").limit(5) if @item.tutorials.present?

    @commentable = @item
    @comments = @commentable.root_comments.order("created_at ASC")
    
    if user_signed_in?
      @comment = Comment.build_from(@commentable, current_user.id, "") 
    else
      @comment = Comment.new
    end

    #if cannot? :manage, @item
    if !(user_signed_in? && current_user.can_update?(@item))
      @item.increment_view_count 
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  def destroy
    @item = @itemizable.items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to @itemizable }
      format.json { head :no_content }
    end
  end  

  def unitemize 
    puts "params[:id] : #{params[:item_id]}"
    @item = @itemizable.items.find(params[:item_id])
    itemization = @itemizable.itemizations.find_by_item_id(@item.id)
    itemization.destroy

    redirect_to @itemizable

  end

  private
  def load_itemizable
    resource, id = request.path.split('/')[1,2]
    @itemizable = resource.singularize.classify.constantize.find(id)
  end
end
