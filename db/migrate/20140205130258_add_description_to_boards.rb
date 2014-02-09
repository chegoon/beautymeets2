class AddDescriptionToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :description, :text
    remove_column :boards, :desc
  end
end
