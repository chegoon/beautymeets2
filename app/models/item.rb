class Item < ActiveRecord::Base
  include PublicActivity::Common

  resourcify

  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :created_at

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :brand
  attr_accessible :description, :name, :view_count, :picture_id, :brand_name, :tag_list
  
  has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
  has_many :itemizations, dependent: :destroy  
  belongs_to :itemizable, polymorphic: true
  has_many :tutorials, through: :itemizations, source: :itemizable, source_type: 'Tutorial'
  has_many :videos, through: :itemizations, source: :itemizable, source_type: 'Video'
  
  has_many :comments, :as => :commentable

  def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end

	def brand_name
	  #brand.name if brand
	  brand.try(:name)
	end
	  
	def brand_name=(name)
	  self.brand = Brand.find_or_create_by_name(name) if name.present?
	end
end
