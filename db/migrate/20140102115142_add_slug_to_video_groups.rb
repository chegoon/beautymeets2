class AddSlugToVideoGroups < ActiveRecord::Migration
  def change
    add_column :video_groups, :slug, :string
    add_index :video_groups, :slug
  end
end
