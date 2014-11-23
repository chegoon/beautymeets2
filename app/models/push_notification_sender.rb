class PushNotificationSender
	#include HTTParty
  # PushNotification.new.notify_all("This is a test notification to all devices")
  def self.notify_all(message)

	@auth = {:application  => "CACFF-A127A", :auth => "3noLcqu96RSXmnoUTL8fTUuy5ZSMFhfGUUVq2sr9LLBuytvavmk7tLonAatvZE8mlMSQ8LR7KlQtMKoeh3bT"}
	self.notify_devices({:content  => message})
  end
   
  # PushNotification.new.notify_device({
  #  :content  => "TEST",
  #  :data  => {:custom_data  => value},
  #  :devices  => array_of_tokens
  #})
  def self.notify_devices(notification_options = {})
	@auth = {:application  => "CACFF-A127A", :auth => "3noLcqu96RSXmnoUTL8fTUuy5ZSMFhfGUUVq2sr9LLBuytvavmk7tLonAatvZE8mlMSQ8LR7KlQtMKoeh3bT"}
	#- Default options, uncomment :data or :devices if needed
	default_notification_options = {
						# YYYY-MM-DD HH:mm  OR 'now'
						:send_date  => "now",
						# Object( language1: 'content1', language2: 'content2' ) OR string
						#:content  => {
						#	:fr  => "Test",
						#	:en  => "Test"
						#},
						# JSON string or JSON object "custom": "json data"
						#:data  => {
						#    :custom_data  => value
						#},
						# omit this field (push notification will be delivered to all the devices for the application), or provide the list of devices IDs
						#:devices  => {}
					  }
					   
	#- Merging with specific options
	final_notification_options = default_notification_options.merge(notification_options)
 
	#- Constructing the final call
	options = @auth.merge({:notifications  => [final_notification_options]})
	options = {:request  => options}                                                                                                                             
	#- Executing the POST API Call with HTTPARTY - :body => options.to_json allows us to send the json as an object instead of a string
	response = HTTParty.post("https://cp.pushwoosh.com/json/1.3/createMessage", :body  => options.to_json,:headers => { 'Content-Type' => 'application/json' })

	return response
  end

end