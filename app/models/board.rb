class Board < ActiveRecord::Base
  include PublicActivity::Common
  
  resourcify
  
  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :created_at
  
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  belongs_to :author, class_name: "User", :foreign_key => "user_id"
  attr_accessible  :title, :view_count, :tag_list, :description, :category_ids, :picture_id, :published
	
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

end
