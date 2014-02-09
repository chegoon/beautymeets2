class AddDescriptionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text
    remove_column :events, :desc
  end
end
