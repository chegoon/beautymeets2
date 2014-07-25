class AddJoinedForToUsers < ActiveRecord::Migration
  def change
    add_column :users, :joined_for, :string
  end
end
