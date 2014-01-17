class DeleteCategorizableToCategories < ActiveRecord::Migration
  def up
  	remove_column :categories, :categorizable_id
  	remove_column :categories, :categorizable_type
  end

  def down
  	add_column :categories, :categorizable_id, :integer
  	add_column :categories, :categorizable_type, :string
  end
end
