class Item < ActiveRecord::Base
  include PublicActivity::Common

  resourcify
  include Authority::Abilities

  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :updated_at

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :brand
  attr_accessible :description, :name, :view_count, :brand_name, :tag_list, :picture_id
  
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
  
  # Method for bookmark
  def self.get_title(id)
    #self.try(:name)
    (find_by_slug(id) || find_by_id(id)).name
  end

  def self.get_description(id)
    (find_by_slug(id) || find_by_id(id)).description
  end
  
  def self.find_id_by_site_url(site_url)
    url = site_url.split(%r{/})
    (find_by_slug(url[2]) && find_by_slug(url[2]).id) || site_url.split(%r{/})[2]
  end
  def reply_enabled 
    return false
  end
end
