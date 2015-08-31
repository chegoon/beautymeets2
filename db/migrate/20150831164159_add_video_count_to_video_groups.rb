class AddVideoCountToVideoGroups < ActiveRecord::Migration
  def change
  	add_column :video_groups, :video_count, :integer
  	add_column :video_groups, :ch_id, :string
  end
end
