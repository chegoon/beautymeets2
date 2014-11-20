class Device < ActiveRecord::Base
  attr_accessible :description, :name, :os_type, :os_version
end
