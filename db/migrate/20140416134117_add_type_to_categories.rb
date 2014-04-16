class AddTypeToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :category_type_id, :integer
    add_index :categories, :category_type_id
  end
end
