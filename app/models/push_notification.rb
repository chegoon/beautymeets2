class PushNotification < ActiveRecord::Base

  attr_accessible :body, :sent, :title, :url

  resourcify
  include Authority::Abilities
  self.authorizer_name = "AdminAuthorizer"

end
