class AddDescriptionToTutorials < ActiveRecord::Migration
  def change
    add_column :tutorials, :description, :text
  end
end
