class AddTargetUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :target_url, :string
  end
end
