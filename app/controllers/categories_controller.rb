class CategoriesController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]
  #before_filter :load_categorizable, except: [:index, :new]

  def index
    #@categories = @categorizable.categories
    @categories = Category.all
  end


  def new
    @category = Category.new
  end
=begin
  def create
    @category = @categorizable.categories.new(params[:category])
    if @category.save
      redirect_to @categorizable, notice: "Category created."
    else
      render :new
    end
  end

	private
  def load_categorizable
    resource, id = request.path.split('/')[1,2]
    @categorizable = resource.singularize.classify.constantize.find(id)
  end
=end
end
