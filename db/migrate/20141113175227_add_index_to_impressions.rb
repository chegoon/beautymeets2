class AddIndexToImpressions < ActiveRecord::Migration
  def change
  	add_index :impressions, :created_at
  	add_index :impressions, :impressionable_id
  	add_index :impressions, :impressionable_type
  end
end
