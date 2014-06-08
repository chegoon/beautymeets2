class CreateChannelLogs < ActiveRecord::Migration
  def change
    create_table :channel_logs do |t|
      t.integer :channel_loggable_id
      t.string :channel_loggable_type
      t.string :url
      t.datetime :uploaded_at
      t.references :channel

      t.timestamps
    end
    add_index :channel_logs, :channel_id
  end
end
