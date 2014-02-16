class Beautystar < ActiveRecord::Base

  include PublicActivity::Common

  #after_validation :set_slug

  extend FriendlyId
  friendly_id :username, use:  [:slugged, :history]
  
  acts_as_taggable
  
  resourcify
  include Authority::Abilities
  self.authorizer_name = 'BeautystarAuthorizer'
  
  #belongs_to :user
  has_one :user, as: :profile#, dependent: :destroy
  attr_accessible :fullname, :introduction, :job_title, :view_count, :vimeo_url, :slug, :tag_list, :image
  
  has_many :pictures, as: :pictureable, dependent: :destroy
  
  mount_uploader :image, ImageUploader

  def username
    #a = User.where("profile_id = ? AND profile_type = 'Beautystar'", self.id).pluck(:username)
    # 아래 callt시 user null return 발w
  	self.user.try(:name)

  end

end
