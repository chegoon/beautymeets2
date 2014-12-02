class Board < ActiveRecord::Base
	include PublicActivity::Common
	
	resourcify
	include Authority::Abilities
	self.authorizer_name = "BasicAuthorizer"
	
	acts_as_taggable

	acts_as_commentable
	
	#has_many :pictures, as: :pictureable, dependent: :destroy
	has_one :picture, as: :pictureable, dependent: :destroy
	accepts_nested_attributes_for :picture, allow_destroy: true, :reject_if => lambda { |a| a['image'].blank? }
	#has_one :thumbnail, class_name: "Picture", as: :pictureable, dependent: :destroy
	#accepts_nested_attributes_for :thumbnail, allow_destroy: true, :reject_if => lambda { |a| a['image'].blank? }
	

	belongs_to :author, class_name: "User", :foreign_key => "user_id"
	attr_accessible  :title, :view_count, :tag_list, :description, :picture_attributes

	has_many :comments, :as => :commentable
	
	def increment_view_count(by = 1)
		self.view_count ||= 0
		self.view_count += by
		self.save
	end

end
