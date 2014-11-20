class AddUuidToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :uuid, :string
    add_index :devices, :uuid
  end
end
