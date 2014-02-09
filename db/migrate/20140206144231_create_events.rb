class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :desc
      t.references :user
      t.references :picture
      t.integer :view_count
      t.datetime :start_from
      t.datetime :finish_on
      t.datetime :win_released_at
      t.datetime :released_at

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :picture_id
  end
end
