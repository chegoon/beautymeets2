class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.references :user
      t.references :beautyclass
      t.references :checkout_status
      t.text :description

      t.timestamps
    end
    add_index :checkouts, :beautyclass_id
  end
end
