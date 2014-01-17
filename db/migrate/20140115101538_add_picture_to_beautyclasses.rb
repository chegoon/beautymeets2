class AddPictureToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :picture_id, :integer
    add_index :beautyclasses, :picture_id
  end
end
