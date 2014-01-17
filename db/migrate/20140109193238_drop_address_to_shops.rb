class DropAddressToShops < ActiveRecord::Migration
  def up
  	remove_column :shops, :address
  	#add_column :shops, :location_id, :integer
  	#add_index :shops, :location_id
  end

  def down
  	add_column :shops, :address
  	#remove_column :shops, :location_id
  	#remove_index :shops, :location_id
  end
end
