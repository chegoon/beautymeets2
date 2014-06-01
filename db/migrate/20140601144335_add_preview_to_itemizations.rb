class AddPreviewToItemizations < ActiveRecord::Migration
  def change
    add_column :itemizations, :preview, :boolean
  end
end
