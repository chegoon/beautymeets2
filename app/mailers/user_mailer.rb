class UserMailer < Devise::Mailer #ActionMailer::Base 
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: "hellobeauty@reallplay.com"
	
	def welcome(user)
		puts "usermailer welcome , #{user} "
 		@user = user
    @url  = "http://www.BEAUTYMEETS.com"
		
		mail(:to => user.email, :subject => "Welcome to BEAUTYMEETS")
	end

	def beautyclass_request(beautyclass, checkout, star, requester)
		@beautyclass = beautyclass
		@checkout = checkout
		@beautystar = star
 		@user = requester
    @url  = "http://www.BEAUTYMEETS.com"
		
		mail(:to => "hellobeauty@reallplay.com", :subject => "Beautyclass#{@beautyclass.title.to_s} Request from #{@user.email.to_s}")
	end
end
