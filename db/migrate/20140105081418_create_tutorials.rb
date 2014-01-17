class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string :title
      t.text :desc
      t.string :vimeo_url
      t.references :user
      t.integer :view_count
      t.boolean :published

      t.timestamps
    end
    add_index :tutorials, :user_id
  end
end
