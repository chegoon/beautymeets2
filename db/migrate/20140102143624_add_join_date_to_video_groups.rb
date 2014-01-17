class AddJoinDateToVideoGroups < ActiveRecord::Migration
  def change
    add_column :video_groups, :join_date, :datetime
    add_column :video_groups, :subscribers, :integer
  end
end
