class AddPublishedToVideoGroups < ActiveRecord::Migration
  def change
    add_column :video_groups, :published, :boolean
  end
end
