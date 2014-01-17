class AddHeaderBgUrlToVideoGroups < ActiveRecord::Migration
  def change
    add_column :video_groups, :header_bg_url, :string
  end
end
