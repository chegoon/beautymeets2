class Suggest < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title

  include PublicActivity::Common
	
	resourcify
	include Authority::Abilities
	self.authorizer_name = "BasicAuthorizer"
	
end
