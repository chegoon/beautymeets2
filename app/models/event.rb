class Event < ActiveRecord::Base
  include PublicActivity::Common
  
  resourcify
  
  acts_as_taggable

  acts_as_commentable

  acts_as_readable :on => :created_at

  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :description, :finish_on, :released_at, :win_released_at, :start_from, :title, :view_count, :tag_list, :picture_id  

  belongs_to :host, class_name: "User", :foreign_key => "user_id"

  has_many :pictures, as: :pictureable, dependent: :destroy

  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
  has_many :entrants, class_name: "User", :foreign_key => "user_id", through: :event_entrys
  has_many :event_entrys

  has_many :categories, through: :categorizations
  has_many :categorizations, as: :categorizeable  


  
  has_many :comments, :as => :commentable
  
	def increment_view_count(by = 1)
	  self.view_count ||= 0
	  self.view_count += by
	  self.save
	end

  def reply_enabled
    return false
  end
end
