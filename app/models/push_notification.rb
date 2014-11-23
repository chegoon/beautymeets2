class PushNotification < ActiveRecord::Base

  attr_accessible :body, :sent, :title

  resourcify
  include Authority::Abilities
  self.authorizer_name = "AdminAuthorizer"

end
