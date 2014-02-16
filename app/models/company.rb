class Company < ActiveRecord::Base

  resourcify
  include Authority::Abilities
  
  attr_accessible :description, :name, :view_count
  has_many :brands
  
  def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end
end
