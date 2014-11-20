module API
	class DevicesController < API::BaseController
		def create
			device = Device.find_or_create_by_uuid(uuid: params[:device][:uuid])
			device.platform_type = params[:device][:platform_type]
			device.platform_version = params[:device][:platform_version]
			device.name = params[:device][:name]
			if device.save
				render :status => 200, :json => { :success => true, :info => "device info updated"}
			end
		end
	end
end
