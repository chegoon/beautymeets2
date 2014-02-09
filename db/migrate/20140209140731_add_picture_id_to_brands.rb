class AddPictureIdToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :picture_id, :integer
    add_index :brands, :picture_id
  end
end
