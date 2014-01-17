class AddBuyerinfosToCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :buyer_name, :string
    add_column :checkouts, :buyer_tel, :string
  end
end
