class PushesController < InheritedResources::Base
	#inherit_resources
	authorize_actions_for Notice, except: [:index, :show]

	#- PushWoosh API Documentation http://www.pushwoosh.com/programming-push-notification/pushwoosh-push-notification-remote-api/ 
	#- Two methods here:
	#     - PushNotification.new.notify_all(message) Notifies all with the same option
	#     - PushNotification.new.notify_devices(notification_options = {}) Notifies specific devices with custom options
	 
	include HTTParty #Make sure to have the HTTParty gem declared in your gemfile https://github.com/jnunemaker/httparty
	#default_params <img src="https://www.pushwoosh.com/wp-includes/images/smilies/icon_surprised.gif" alt=":o" class="wp-smiley"> output => 'json'
	format :json
	 
	def send

		@push = Push.find(params[:id])
		Push.notify_all(@push.body)
		@push.sent = true
		
		respond_to do |format|
			if @push.save
				format.html { redirect_to @push, notice: 'Push was successfully created.' }
				format.json { render json: @push, status: :created, location: @push }
			else
				format.html { render action: "new" }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
		
	end
=begin
	 def send
		push = Push.find(params[:id])
		Push.notify_all(push.body)
	
	 end
=end
end
