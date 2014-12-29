class Collection < ActiveRecord::Base

	acts_as_taggable

	acts_as_commentable

	resourcify
	include Authority::Abilities

	extend FriendlyId
	friendly_id :url_candidate, use: [:slugged, :history]
  
	belongs_to :user
	belongs_to :picture
	attr_accessible :description, :title, :view_count, :user_id, :picture_id, :category_ids, :published, :url_candidate

	has_many :collectings, dependent: :destroy
	belongs_to :collectable, polymorphic: true

	has_many :categories, through: :categorizations
	has_many :categorizations, as: :categorizeable  

	has_many :videos, through: :collectings, source: :collectable, source_type: 'Video'
	has_many :posts, through: :collectings, source: :collectable, source_type: 'Post'
	has_many :tutorials, through: :collectings, source: :collectable, source_type: 'Tutorial'
	has_many :items, through: :collectings, source: :collectable, source_type: 'Item'

	has_many :pictures, as: :pictureable, dependent: :destroy
	belongs_to :thumbnail, class_name: "Picture", :foreign_key => "picture_id"
	
	def increment_view_count(by = 1)
		self.view_count ||= 0
		self.view_count += by
		self.save
	end

	def post_urls

	end
	def post_url

	end
end
