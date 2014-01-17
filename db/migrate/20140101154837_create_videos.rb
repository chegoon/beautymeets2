class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.integer :view_count
      t.references :video_group
      t.string :thumb_url
      t.string :image
      t.string :thumb_url
      t.string :video_url
      t.datetime :published_at
      t.boolean :published
      t.integer :duration

      t.timestamps
    end
    add_index :videos, :video_group_id
  end
end
