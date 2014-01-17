class CreateVideoGroups < ActiveRecord::Migration
  def change
    create_table :video_groups do |t|
      t.string :name
      t.string :home_url
      t.string :thumb_url
      t.string :image
      t.string :youtube_id
      t.integer :view_count

      t.timestamps
    end
  end
end
