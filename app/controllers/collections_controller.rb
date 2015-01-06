class CollectionsController < ApplicationController
	inherit_resources

	# POST /events
	# POST /events.json
	def create
		@collection = current_user.collections.create(params[:collection])
		current_user.add_role :author, @collection

		respond_to do |format|
			if @collection.save
				format.html { redirect_to controller: "collections", action: "show", id: @collection.id, notice: 'Event was successfully created.' }
				format.json { render json: @collection, status: :created, location: @collection }
			else
				format.html { render action: "new" }
				format.json { render json: @collection.errors, status: :unprocessable_entity }
			end
		end
	end
	def show
		@collection = Collection.find(params[:id])

		@pictureable = @collection
		@pictures = @pictureable.pictures
		@picture = Picture.new

		@collection.increment_view_count 
		impressionist(@collection)

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @collection }
		end
	end
	def update
		@collection = Collection.find(params[:id])
		url = params[:post_url] if params[:post_url]

		respond_to do |format|
			if @collection.update_attributes(params[:collection])
				format.html { redirect_to controller: "collections", action: "show", id: @collection.id, notice: 'Collection was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @collection.errors, status: :unprocessable_entity }
			end
		end
	end

	def drop_collecting 
		load_collectable
		
		@collection = @collectable.collections.find(params[:collection_id])
		colleting = @collectable.collectings.find_by_collection_id(@collection.id)
		colleting.destroy

		redirect_to @collectable

	end

	private

	def load_collectable
		resource, id = request.path.split('/')[1,2]
		@collectable = (resource.singularize + "s").classify.constantize.find(id)
	end
end
