class ChangeReadableTypeToActivities < ActiveRecord::Migration
  def up
  	change_column :read_marks, :readable_type, "varchar(255)"
  end

  def down
  	change_column :read_marks, :readable_type, "varchar(20)"
  end
end
