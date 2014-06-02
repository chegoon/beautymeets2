class AddMobileThumbToEvents < ActiveRecord::Migration
  def change
    add_column :events, :mobile_picture_id, :integer
    add_index :events, :mobile_picture_id
  end
end
