class Device < ActiveRecord::Base
	belongs_to :user
	attr_accessible :description, :name, :os_type, :os_version
end
