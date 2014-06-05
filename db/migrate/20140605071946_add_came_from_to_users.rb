class AddCameFromToUsers < ActiveRecord::Migration
  def change
    add_column :users, :came_from, :string
  end
end
