class Notice < ActiveRecord::Base
  attr_accessible :description, :published, :title, :view_count, :user_id
  include PublicActivity::Common
  
  resourcify
  include Authority::Abilities
  
  belongs_to :author, class_name: "User", :foreign_key => "user_id"
  acts_as_taggable

  acts_as_commentable
  
  acts_as_readable :on => :updated_at

  has_many :pictures, as: :pictureable, dependent: :destroy
  belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
  
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
