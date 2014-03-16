class CommentMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.

  default to: "hellobeauty@reallplay.com"
	
	def create_notification(commentable, comment)
 		@commentable = commentable
    @comment  = comment
		
		#mail(:to => @commentable.author.email, :from => @comment.user.email, :subject => "#{@commentable.try(:title)}에 댓글이 달렸습니다.")
		#mail(:from => @comment.user.email, :subject => "[BEAUTYMEETS] 1 comment on [#{@commentable.class.name.split('::').last}] #{@commentable.try(:title)}")
		mail(:from => @comment.user.email, :subject => "[BEAUTYMEETS] 1 comment on #{@commentable.try(:title)}")
	end

	def parent_notification(parent, commentable, comment)
		@parent = parent
 		@commentable = commentable
    @comment  = comment

    #mail(:to => @parent.user.email, :subject => "#{@commentable.try(:title)}에 작성한 댓글에 답변이 달렸습니다.")
    mail(:to => @parent.user.email, :from => @comment.user.email, :subject => "[BEAUTYMEETS] 1 reply on your comment on #{@commentable.try(:title)}")
	end

end
