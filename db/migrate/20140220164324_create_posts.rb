class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.string :title
      t.integer :view_count
      t.text :description
      t.references :picture
      t.boolean :published
      t.string :url_candidate
      t.string :slug

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :picture_id
  end
end
