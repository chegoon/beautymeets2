OmniAuth.config.logger = Rails.logger
#The below code commented out because of setup in devise.rb already

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'xfpJBsdxfbtngcAaJgL7VQ', 'soPkpZEddjI4R7oiwMXfWB6AmmoAAHp2FjURcRTyaT0'  
  provider :facebook, '550803185011643', '69a53cecf6e1ca905711b03b1cde518c'
end
