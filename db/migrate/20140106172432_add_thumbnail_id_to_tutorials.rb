class AddThumbnailIdToTutorials < ActiveRecord::Migration
  def change
    add_column :tutorials, :picture_id, :integer
    add_index :tutorials, :picture_id
  end
end
