class CommentMailer < ActionMailer::Base
	helper :application # gives access to all helpers defined within `application_helper`.
	
	def create_notification(commentable, comment)
		@commentable = commentable
		@comment  = comment

		if (@commentable.class.name == "Item")
			mailer_title = @commentable.try(:name)
		else
			mailer_title = @commentable.try(:title)
		end
		
		mail(:to => "hellobeauty@reallplay.com", :from => @comment.user.email, :subject => "[BEAUTYMEETS] 1 comment on #{mailer_title}")
	end

	def parent_notification(parent, commentable, comment)
		@parent = parent
		@commentable = commentable
		@comment  = comment
		
		if (@commentable.class.name == "Item")
			mailer_title = @commentable.try(:name)
		else
			mailer_title = @commentable.try(:title)
		end

		mail(:to => @parent.user.email, :from => @comment.user.email, :subject => "[BEAUTYMEETS] 1 reply on your comment on #{mailer_title}")
	end

end
