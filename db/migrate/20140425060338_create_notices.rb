class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.text :description
      t.integer :view_count
      t.boolean :published
      t.references :user
      t.references :picture

      t.timestamps
    end
    add_index :notices, :user_id
    add_index :notices, :picture_id
  end
end
