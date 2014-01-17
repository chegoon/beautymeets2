class Brand < ActiveRecord::Base
  resourcify

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :company
  attr_accessible :description, :name, :view_count

  has_many :items

  def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end
end
