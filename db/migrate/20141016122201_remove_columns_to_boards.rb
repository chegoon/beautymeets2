class RemoveColumnsToBoards < ActiveRecord::Migration
  def up
  	remove_column :boards, :picture_id
  	remove_column :boards, :published
  	remove_column :boards, :url_candidate
  end

  def down
  	add_column :boards, :picture_id, :integer
  	add_column :boards, :published
  	add_column :boards, :url_candidate
  end
end
