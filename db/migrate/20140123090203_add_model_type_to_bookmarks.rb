class AddModelTypeToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :model_id, :integer
    add_column :bookmarks, :model_type_id, :integer
    add_index :bookmarks, [:model_id, :model_type_id]
  end
end
