class CreateCheckoutStatuses < ActiveRecord::Migration
  def change
    create_table :checkout_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
