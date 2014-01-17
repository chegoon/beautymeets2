class AddViewCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :view_count, :integer
  end
end
