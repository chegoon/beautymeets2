class Picture < ActiveRecord::Base
	resourcify
	
	include PublicActivity::Common

	attr_accessible :image, :description

	belongs_to :pictureable, polymorphic: true
	
	mount_uploader :image, ImageUploader

end
