class AddAnnouncementClosedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :announcement_closed_at, :datetime
  end
end
