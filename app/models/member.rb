class Member < ActiveRecord::Base
  include PublicActivity::Common
  
  extend FriendlyId
  friendly_id :username, use:  [:slugged, :history]
  
  resourcify
  include Authority::Abilities
  self.authorizer_name = 'MemberAuthorizer'

  acts_as_taggable_on :skin_types, :skin_troubles, :skin_tones, :skin_brightnesses, :skin_colors, :eye_types

  attr_accessible :year_of_birth, :gender_id, :slug, :skin_type_list, :eye_type_list, :skin_trouble_list, :skin_tone_list, :skin_brightness_list, :skin_color_list

  #validates :year_of_birth, :length => { :is => 4 }, numericality: { :only_integer => true, :greater_than_or_equal_to => 1970, :less_than_or_equal_to => 2010 }, presence: true
  
  belongs_to :gender
  has_one :user, as: :profile#, dependent: :destroy
  
  has_many :categorizations, as: :categorizeable
  has_many :categories, through: :categorizations

  def username
  	user.try(:username)
  end
end
