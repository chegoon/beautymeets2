class RenameCategorizeableToCategorizations < ActiveRecord::Migration
  def up
  	rename_column :categorizations, :categorizable_id, :categorizeable_id
  	rename_column :categorizations, :categorizable_type, :categorizeable_type
  end

  def down
  	rename_column :categorizations, :categorizeable_id, :categorizable_id
  	rename_column :categorizations, :categorizeable_type, :categorizable_type
  end
end
