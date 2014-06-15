class RenamePreviewToItemizations < ActiveRecord::Migration
  def up
  	rename_column :itemizations, :preview, :featured
  end

  def down
  	rename_column :itemizations, :featured, :preview
  end
end
