class AddDescriptionToVideoGroups < ActiveRecord::Migration
  def change
    add_column :video_groups, :description, :text
  end
end
