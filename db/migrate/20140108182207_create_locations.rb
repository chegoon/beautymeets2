class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :description
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.integer :view_count

      t.timestamps
    end
  end
end
