class AddPublishedToItems < ActiveRecord::Migration
  def change
    add_column :items, :published, :boolean
  end
end
