class Beautyclass < ActiveRecord::Base
	
  include PublicActivity::Common

  resourcify
  
  acts_as_taggable

  acts_as_commentable

  acts_as_readable :on => :created_at
  
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :bookmarks, :as => :bookmarkable

  belongs_to :author, class_name: "User", :foreign_key => "user_id"
  attr_accessible :price, :capacity, :description, :published, :closed, :title, :view_count, :picture_id, :tag_list, :category_ids, :location_attributes, :where, :picture_id

	has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
  has_many :categories, through: :categorizations
  has_many :categorizations, as: :categorizeable  

  has_many :comments, :as => :commentable

  belongs_to :location

  has_many :checkouts
	
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
    self.capacity - self.checkouts.where(checkout_status_id: CheckoutStatus.find_by_name("Payment Confirmed").id).count
  end
end
