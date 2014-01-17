class RenameSoldoutToBeautyclasses < ActiveRecord::Migration
  def up
  	rename_column :beautyclasses, :soldout, :closed
  end

  def down
  	rename_column :beautyclasses, :closed, :soldout
  end
end
