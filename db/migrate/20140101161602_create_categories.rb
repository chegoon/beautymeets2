class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.belongs_to :categorizable, polymorphic: true
      t.integer :parent_id

      t.timestamps
    end
    add_index :categories, :parent_id
    add_index :categories, [:categorizable_id, :categorizable_type]
  end
end
