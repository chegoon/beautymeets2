class CreateSuggests < ActiveRecord::Migration
  def change
    create_table :suggests do |t|
      t.references :user
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :suggests, :user_id
  end
end
