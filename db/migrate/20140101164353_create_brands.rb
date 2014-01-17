class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.references :company
      t.string :name
      t.text :description
      t.string :image
      t.integer :view_count

      t.timestamps
    end
    add_index :brands, :company_id
  end
end
