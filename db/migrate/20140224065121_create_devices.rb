class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id
      t.references :user
      t.string :name
      t.string :os_type
      t.string :os_version
      t.boolean :push_notification
      t.text :description

      t.timestamps
    end
    add_index :devices, :user_id
  end
end
