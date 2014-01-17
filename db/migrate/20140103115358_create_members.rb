class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :gender
      t.integer :birth_of_year

      t.timestamps
    end
    add_index :members, :gender_id
  end
end
