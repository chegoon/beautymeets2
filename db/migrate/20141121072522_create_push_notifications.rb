class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
      t.string :title
      t.string :body
      t.boolean :sent

      t.timestamps
    end
  end
end
