class Itemization < ActiveRecord::Base
  belongs_to :item
  belongs_to :itemizable, polymorphic: true
  attr_accessible :item_id, :preview
end
