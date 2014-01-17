class Shop < ActiveRecord::Base
  attr_accessible  :description, :name, :location_attributes
  has_many :beautyclasses
  has_one :location

  accepts_nested_attributes_for :location, :allow_destroy => true
end
