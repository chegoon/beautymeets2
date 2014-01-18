class AddRemoteImageUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remote_image_url, :string
  end
end
