class CreateChannelLogDetails < ActiveRecord::Migration
  def change
    create_table :channel_log_details do |t|
      t.references :channel_log
      t.integer :view_count
      t.integer :like_count
      t.integer :comment_count
      t.integer :share_count
      t.datetime :collected_at

      t.timestamps
    end
    add_index :channel_log_details, :channel_log_id
  end
end
