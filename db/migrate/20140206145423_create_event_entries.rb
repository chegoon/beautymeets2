class CreateEventEntries < ActiveRecord::Migration
  def change
    create_table :event_entries do |t|
      t.references :event
      t.references :user
      t.string :description

      t.timestamps
    end
    add_index :event_entries, :event_id
    add_index :event_entries, :user_id
  end
end
