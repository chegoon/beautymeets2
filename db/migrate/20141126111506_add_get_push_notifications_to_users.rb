class AddGetPushNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :get_push_notifications, :boolean, :default => true
  end
end
