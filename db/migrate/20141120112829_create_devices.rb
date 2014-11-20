class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :os_type
      t.string :os_version
      t.text :description

      t.timestamps
    end
  end
end
