class AddYtViIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :yt_vi_id, :string
  end
end
