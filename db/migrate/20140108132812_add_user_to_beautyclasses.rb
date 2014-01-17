class AddUserToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :user_id, :integer
    add_index :beautyclasses, :user_id
  end
end
