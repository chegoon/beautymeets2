class AddRequestsToCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :private_start_date, :datetime
    add_column :checkouts, :private_end_date, :datetime
    add_column :checkouts, :private_seat, :integer
  end
end
