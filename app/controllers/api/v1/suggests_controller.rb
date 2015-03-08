module API
	module V1
		class SuggestsController < API::V1::BaseController
			before_filter :set_current_user
			
			# GET /suggests
			# GET /suggests.json
			def index

				offset = params[:offset] || 0
				limit = params[:limit] || 12

				@suggests = suggest.order("created_at DESC").offset(offset).limit(limit)

				respond_to do |format|
					#format.html # index.html.erb
					format.json 
				end
			end

			def show
				@suggest = suggest.find(params[:id])
				
				@suggest.increment_view_count 
							
			end

			# POST /suggests
			# POST /suggests.json
			def create
				if params[:image]
					suggest_params = JSON.parse(params[:suggest])
					@suggest = @user.suggests.new({user_id: @user.id, title: suggest_params['title'],  description: suggest_params['description'], picture_attributes: {image: params[:image]}}) 
				else
					@suggest = @user.suggests.create({title: params[:suggest][:title], description: params[:suggest][:description]})	
				end

				respond_to do |format|
					if @suggest.save
						@user.add_role :author, @suggest
						format.html { redirect_to @suggest, notice: 'suggest was successfully created.' }
						format.json { render json: @suggest, status: :created, location: @suggest }
					else
						format.html { render action: "new" }
						format.json { render json: @suggest.errors, status: :unprocessable_entity }
					end
				end
			end

			def update
				@suggest = suggest.find(params[:id])

				respond_to do |format|
					if @suggest.update_attributes(params[:suggest])
						format.html { redirect_to @suggest, notice: 'suggest was successfully updated.' }
						format.json { head :no_content }
					else
						format.html { render action: "edit" }
						format.json { render json: @suggest.errors, status: :unprocessable_entity }
					end
				end
			end

			def destroy
				@suggest = suggest.find(params[:id])
				@suggest.destroy

				respond_to do |format|
					format.html { redirect_to @suggest, notice: "suggest destroied"  }
					format.js
					format.json { head :no_content }
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
