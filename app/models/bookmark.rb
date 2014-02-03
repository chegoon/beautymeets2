class Bookmark < ActiveRecord::Base
  attr_accessible :bookmarkable, :note, :user_id, :model_type_id, :model_id

  belongs_to :bookmarkable, :polymorphic => true
  belongs_to :user

  def self.find_bookmark(user_id,model_type_id,model_id)
    find(
      :first,
      :conditions => ["user_id = ? AND model_type_id = ? AND model_id = ?", 
               user_id, model_type_id, model_id],
      :limit => 1
    )
  end

  def self.is_bookmarked?(user_id,model_type_id,model_id)
    find_bookmark(user_id, model_type_id, model_id)
  end
end
