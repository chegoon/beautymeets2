class AddFavoriteCountToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :favorite_count, :integer
  end
end
