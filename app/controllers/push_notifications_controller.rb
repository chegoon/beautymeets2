require 'HTTParty'
class PushNotificationsController < InheritedResources::Base
#	require 'net/https'
#	require 'open-uri'

	def call_send

		@push = PushNotification.find(params[:id])
		#PushNotification.notify_all(@push.body)
		auth = {:application  => "CACFF-A127A", :auth => "3noLcqu96RSXmnoUTL8fTUuy5ZSMFhfGUUVq2sr9LLBuytvavmk7tLonAatvZE8mlMSQ8LR7KlQtMKoeh3bT"}
		default_notification_options = {
						# YYYY-MM-DD HH:mm  OR 'now'
						:send_date  => "now",
						# Object( language1: 'content1', language2: 'content2' ) OR string
						:content  => {
							:fr  => "Test",
							:en  => "Test"
						},
						# JSON string or JSON object "custom": "json data"
						#:data  => {
						#    :custom_data  => value
						#},
						# omit this field (push notification will be delivered to all the devices for the application), or provide the list of devices IDs
						#:devices  => {}
					  }
					   
		#- Merging with specific options
		final_notification_options = default_notification_options.merge({:content => @push.body})
		#- Constructing the final call
		options = auth.merge({:notifications  => [final_notification_options]})
		options = {:request  => options}                                                                                                                             
		#- Executing the POST API Call with HTTPARTY - :body => options.to_json allows us to send the json as an object instead of a string
		response = HTTParty.post("https://cp.pushwoosh.com/json/1.3/createMessage", :body  => options.to_json,:headers => { 'Content-Type' => 'application/json' })

=begin
		url = URI.parse('https://cp.pushwoosh.com/json/1.3/createMessage')
		req = Net::HTTP::Post.new(url.path)
		req.form_data = data
		req.basic_auth url.user, url.password if url.user
		con = Net::HTTP.new(url.host, url.port)
		con.use_ssl = true
		con.start {|http| http.request(req)}
=end

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
