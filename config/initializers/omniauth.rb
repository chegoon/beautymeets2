OmniAuth.config.logger = Rails.logger
#The below code commented out because of setup in devise.rb already

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'xfpJBsdxfbtngcAaJgL7VQ', 'soPkpZEddjI4R7oiwMXfWB6AmmoAAHp2FjURcRTyaT0'  
  provider :facebook, '143298282497081', '84b74288ea8f52863a5330aa2dcbe5da'
end
