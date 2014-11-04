class AddMenuIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :menu_id, :integer
    add_index :categories, :menu_id
  end
end
