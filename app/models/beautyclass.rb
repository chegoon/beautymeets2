class Beautyclass < ActiveRecord::Base
  include PublicActivity::Common
  #tracked only: :create, owner: Proc.new { |controller, model| controller.current_user && model.published } # && model.acitivites.where(owner: current_user, trackable: model).nil? }

  resourcify
  include Authority::Abilities
  self.authorizer_name = 'BeautystarAuthorizer'
  
  acts_as_taggable

  acts_as_commentable

  acts_as_readable :on => :updated_at
  
  extend FriendlyId
  friendly_id :url_candidate, use: [:slugged, :history]

  belongs_to :author, class_name: "User", :foreign_key => "user_id"
  attr_accessible :price, :capacity, :description, :published, :closed, :title, :view_count, :picture_id, :tag_list, :category_ids, :location_attributes, :where, :picture_id, :location_name, :review_url, :start_date, :end_date, :url_candidate

	has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
  has_many :categories, through: :categorizations
  has_many :categorizations, as: :categorizeable  

  has_many :comments, :as => :commentable

  belongs_to :location

  has_many :checkouts

  mount_uploader :image, ImageUploader
	
  def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end

	def where
		self.location.try(:name) 
	end

  def where=(location_name)
    self.location = Location.find_or_create_by_name(location_name)
    self.location.save
  end

  def seats_available
    (self.capacity || 0) - (self.checkouts.where(checkout_status_id: CheckoutStatus.find_by_name("Payment Confirmed").try(:id)).count || 0)
  end

  def location_name
    self.location.try(:name)
  end

  def location_name=(name)
    self.location = Location.find_or_create_by_name(name) if name.present?
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
