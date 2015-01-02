#require 'HTTParty'
class PushNotificationsController < InheritedResources::Base

	def call_send

		@push = PushNotification.find(params[:id])
		users = User.where(get_push_notifications: true)
		#users = User.where(id: 4)
		devices = Array.new
		users.each do |user|
			user.devices.each do |d|
				devices << d.uuid
			end
		end
		PushNotificationSender.delay.notify_devices({content: @push.body, devices: devices, data:{ url: @push.url }})
		@push.sent = true
		
		respond_to do |format|
			if @push.save
				format.html { redirect_to @push, notice: 'Push was successfully sent.' }
				format.json { render json: @push, status: :created, location: @push }
			else
				format.html { render action: "new" }
				format.json { render json: @push.errors, status: :unprocessable_entity }
			end
		end
		
	end
end
