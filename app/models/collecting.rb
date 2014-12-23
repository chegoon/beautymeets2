class Collecting < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :collection
  belongs_to :collectable, polymorphic: true
  attr_accessible :collection_id
end
