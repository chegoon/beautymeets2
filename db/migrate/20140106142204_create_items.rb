class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :brand
      t.string :name
      t.string :description
      t.integer :view_count

      t.timestamps
    end
    add_index :items, :brand_id
  end
end
