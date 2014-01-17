class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image
      t.belongs_to :pictureable, polymorphic: true

      t.timestamps
    end
    add_index :pictures, [:pictureable_id, :pictureable_type]
  end
end
