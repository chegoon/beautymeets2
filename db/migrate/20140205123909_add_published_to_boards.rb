class AddPublishedToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :published, :boolean
  end
end
