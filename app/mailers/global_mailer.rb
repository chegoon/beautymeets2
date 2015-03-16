class GlobalMailer < ActionMailer::Base
	helper :application # gives access to all helpers defined within `application_helper`.

	#default to: "hellobeauty@reallplay.com"
	
	def report(sender, title, description)
		@sender = sender
		@title = "[User Report] : #{title}"
		@description = description

		mail(:to => "hellobeauty@reallplay.com", :from => (@sender.email || @sender.name), :subject => @title, :description => @description)
	end
end
