module API
	module V1
		module TV
			class PostsController < API::V1::BaseController
				#before_filter :authenticate_user!
				
				def index

					if params[:offset].present? && !(params[:offset] == "")
						@offset = params[:offset]
					else
						@offset = 0
					end
					@limit = params[:limit] || 12

					#menu = Category.where(name: params[:category], parent_id: Category.find_by_name("menu").id).first
					#@categories = menu ? Category.where(menu_id: menu.id) : nil

					#puts "params : #{params[:category]}"
					#puts "category : #{category}"
					# HOME 

					@categories = Category.where(parent_id: Category.find_by_name("menu").id)

					@connection = ActiveRecord::Base.establish_connection( 
						:adapter => "mysql2",
						:host => "localhost",
						:database => "beautymeets2_production",
						#:database => "beautymeets2_development",
						:username => "root",
						#:password => "bd0516"
						:password => "Reallplay0707"
					)

				end

				def show
					@post = Tutorial.find(params[:id])
				end


			end
		end
	end
end	