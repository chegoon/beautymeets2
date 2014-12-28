module API
	module V1
		class ProfilesController < API::V1::BaseController
			def index
				
				@user = User.find(params[:user_id])
				@member = @user.profile
			end

			def update
				@user = User.find(params[:user_id])
				@member = @user.profile
				if  params[:sub] == 'basic'
					puts "basic #{params[:basic]}"
					@member.year_of_birth = params[:basic][:yearOfBirth]
					@member.gender_id = params[:basic][:genderId]
					#params[:genders].each do |g|
					#	if g[1][:selected] == 'true'
							#@member.gender_id = g[1][:id]
					#	end
					#end
					
				elsif params[:eyeTypes]
					@member.eye_type_list = ''
					params[:eyeTypes].each do |type|

						if type[1][:checked] == 'true'
							@member.eye_type_list << type[1][:name].to_s
						end
					end
					
				elsif params[:skinTypes]
					@member.skin_type_list = ''
					params[:skinTypes].each do |type|

						if type[1][:checked] == 'true'
							@member.skin_type_list << type[1][:name].to_s
						end
					end
				elsif params[:skinBrightnesses]
					@member.skin_brightness_list = ''
					params[:skinBrightnesses].each do |type|

						if type[1][:checked] == 'true'
							@member.skin_brightness_list << type[1][:name].to_s
						end
					end
				elsif params[:skinTones]
					@member.skin_tone_list = ''
					params[:skinTones].each do |type|

						if type[1][:checked] == 'true'
							@member.skin_tone_list << type[1][:name].to_s
						end
					end
				elsif params[:skinColors]
					@member.skin_color_list = ''
					params[:skinColors].each do |type|

						if type[1][:checked] == 'true'
							@member.skin_color_list << type[1][:name].to_s
						end
					end
				elsif params[:skinTroubles]
					@member.skin_trouble_list = ''
					params[:skinTroubles].each do |type|

						if type[1][:checked] == 'true'
							@member.skin_trouble_list << type[1][:name].to_s
						end
					end
				else
				end
				
				if @member.save
					render :status => 200, :json => { :success => true, :info => "Skintypes updated"}
				else
					render :status => 401, :json => { :success => false, :info => "Something wrong on skintype update"}
				end
			end
		end
	end
end
