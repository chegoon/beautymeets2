class Location < ActiveRecord::Base
	before_destroy :reset_location_info
  after_validation :geocode, :if => :address_changed?
  after_update :geocode
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  geocoded_by :address

  attr_accessible :description, :gmaps, :latitude, :longitude, :name, :address, :shop_id
  
  has_many :beautyclasses

  belongs_to :shop

  def reset_location_info
  	if self.beautyclasses.present?
	  	self.beautyclasses.each do |bclass|
	  		bclass.location_id = nil
	  	end
	  end

  	self.shop.location_id = nil if self.shop.present?

  end
end
