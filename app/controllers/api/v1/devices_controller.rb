module API
	module V1
		class DevicesController < API::V1::BaseController
			before_filter :set_current_user
			def create
				device = @user.devices.find_or_create_by_uuid(params[:device][:uuid])
				device.platform_type = params[:device][:platform_type]
				device.platform_version = params[:device][:platform_version]
				device.name = params[:device][:name]
				if device.save
					render :status => 200, :json => { :success => true, :info => "device info updated"}
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
