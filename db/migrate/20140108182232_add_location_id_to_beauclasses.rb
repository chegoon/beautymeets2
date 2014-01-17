class AddLocationIdToBeauclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :location_id, :integer
    add_index :beautyclasses, :location_id
  end
end
