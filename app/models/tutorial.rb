class Tutorial < ActiveRecord::Base
  
  is_impressionable #:counter_cache => true, :unique => :request_hash

  include PublicActivity::Common

  resourcify
  include Authority::Abilities
  self.authorizer_name = 'BeautystarAuthorizer'

  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :updated_at
  
  extend FriendlyId
  friendly_id :url_candidate, use: [:slugged, :history]

  belongs_to :author, class_name: "User", :foreign_key => "user_id"
  attr_accessible :desc, :published, :title, :view_count, :vimeo_url, :tag_list, :description, :category_ids, :picture_id, :item_name, :url_candidate
	
	has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
  has_many :categories, through: :categorizations
  has_many :categorizations, as: :categorizeable  

  has_many :items, through: :itemizations
  has_many :itemizations, as: :itemizable
  
  has_many :comments, :as => :commentable
  
  mount_uploader :image, ImageUploader

	def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end

  def item_name
    self.items.find_by_name(:name)
  end

  def item_name=(name)
    item = Item.find_by_name(name)
    if item.present? 
      itemization = self.itemizations.find_by_item_id(item.id) || self.itemizations.create(item_id: item.id) 
    else
      item = self.items.create(name: name)
    end
  end

  # Method for bookmark
  def self.get_title(id)
    #self.try(:name)
    (find_by_slug(id) || find_by_id(id)).title
  end

  def self.get_description(id)
    (find_by_slug(id) || find_by_id(id)).description
  end
  
  def self.find_id_by_site_url(site_url)
    url = site_url.split(%r{/})
    (find_by_slug(url[2]) && find_by_slug(url[2]).id) || site_url.split(%r{/})[2]
  end

  def reply_enabled 
    return true
  end
end
