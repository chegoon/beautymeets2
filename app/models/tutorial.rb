class Tutorial < ActiveRecord::Base
  include PublicActivity::Common

  resourcify
  
  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :created_at
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_many :bookmarks, :as => :bookmarkable
  
  belongs_to :author, class_name: "User", :foreign_key => "user_id"
  attr_accessible :desc, :published, :title, :view_count, :vimeo_url, :tag_list, :description, :category_ids, :picture_id, :item_name
	
	has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
  has_many :categories, through: :categorizations
  has_many :categorizations, as: :categorizeable  

  has_many :items, through: :itemizations
  has_many :itemizations, as: :itemizable
  
  has_many :comments, :as => :commentable
  
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
end
