class Event < ActiveRecord::Base
  include PublicActivity::Common
  
  resourcify
  include Authority::Abilities
  
  acts_as_taggable

  acts_as_commentable

  acts_as_readable :on => :updated_at

  extend FriendlyId
  friendly_id :url_candidate, use: [:slugged, :history]

  attr_accessible :description, :published, :finish_on, :released_at, :win_released_at, :start_from, :title, :view_count, :tag_list, :picture_id, :target_url, :url_candidate, :announcement_closed_at, :mobile_picture_id, :category_ids

  has_many :categories, through: :categorizations
  has_many :categorizations, as: :categorizeable  

  belongs_to :host, class_name: "User", :foreign_key => "user_id"

  has_many :pictures, as: :pictureable, dependent: :destroy

  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  belongs_to :mobile_thumbnail, class_name: "Picture", :foreign_key => "mobile_picture_id"
  
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
    return true
  end
end
