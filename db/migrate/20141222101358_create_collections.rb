class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title
      t.text :description
      t.references :user
      t.integer :view_count
      t.references :picture

      t.timestamps
    end
    add_index :collections, :user_id
    add_index :collections, :picture_id
  end
end
