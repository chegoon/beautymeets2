class CategoryType < ActiveRecord::Base
  attr_accessible :name
  has_many :categories
end
