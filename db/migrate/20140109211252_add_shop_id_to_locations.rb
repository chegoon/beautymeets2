class AddShopIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :shop_id, :integer
    add_index :locations, :shop_id
  end
end
