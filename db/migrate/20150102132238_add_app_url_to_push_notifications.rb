class AddAppUrlToPushNotifications < ActiveRecord::Migration
  def change
    add_column :push_notifications, :url, :string
  end
end
