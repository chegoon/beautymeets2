class ChangeDescToItems < ActiveRecord::Migration
  def up
  	change_column :items, :description, :text
  end

  def down
  	change_column :items, :description, :string
  end
end
