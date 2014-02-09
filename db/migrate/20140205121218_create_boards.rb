class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.references :picture
      t.references :user
      t.string :desc
      t.integer :view_count

      t.timestamps
    end
    add_index :boards, :picture_id
    add_index :boards, :user_id
  end
end
