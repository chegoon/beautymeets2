OmniAuth.config.logger = Rails.logger
#The below code commented out because of setup in devise.rb already
=begin
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '550803185011643', '69a53cecf6e1ca905711b03b1cde518c'
end
=end