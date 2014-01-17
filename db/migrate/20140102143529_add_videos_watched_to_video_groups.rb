class AddVideosWatchedToVideoGroups < ActiveRecord::Migration
  def change
    add_column :video_groups, :videos_watched, :integer
  end
end
