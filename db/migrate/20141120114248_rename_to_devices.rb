class RenameToDevices < ActiveRecord::Migration
  def up
  	rename_column :devices, :os_type, :platform_type
  	rename_column :devices, :os_version, :platform_version
  end

  def down
  	rename_column :devices, :platform_type, :os_type
  	rename_column :devices, :platform_version, :os_version
  end
end
