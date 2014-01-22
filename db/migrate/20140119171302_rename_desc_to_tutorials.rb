class RenameDescToTutorials < ActiveRecord::Migration
  def up
  	remove_column :tutorials, :desc
  end

  def down
  	add_column :tutorials,  :desc, :string
  end
end
