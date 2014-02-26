#require 'development_mail_interceptor' #add this line
ActionMailer::Base.smtp_settings = {
    :address => 'smtp.gmail.com',
    :port => 587,
    :domain => 'reallplay.com',
    :user_name => 'hellobeauty@reallplay.com',
    :password    => 'reallplay0707',
    :authentication => 'plain',
    :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = "localhost:3000" #"www.beautymeets.com"



# Below config updated to ActionMailer
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
# 개발 모드일때 메일을 특정인에게만 보낼 수 있는 인터셉터
#ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

#PremailerRails.config.merge(:preserve_styles => true,
 #                           :remove_ids      => true)
