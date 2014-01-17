class AddPictureIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :picture_id, :integer
    add_index :items, :picture_id
  end
end
