class PicturesController < ApplicationController
	before_filter :load_pictureable

  def index
    @pictures = @pictureable.pictures
  end

  def new
  end
  
  def create
    @picture = @pictureable.pictures.new(params[:picture])

    current_user.add_role :author, @picture
    #@picture.create_activity :create, owner: @pictureable.author if @pictureable.published?

    if @picture.save
      redirect_to @pictureable, notice: "Picture created."
    else
      render :new
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = @pictureable.pictures.find(params[:id])
    # Thumbnail refer id to be nil
    @pictureable.update_attributes(picture_id: nil)
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to @pictureable }
      format.json { head :no_content }
    end
  end

	private
  def load_pictureable
    resource, id = request.path.split('/')[1,2]
    # classify method is not handled correctly in singular names.
    @pictureable = (resource.singularize + "s").classify.constantize.find(id)
  end
end
