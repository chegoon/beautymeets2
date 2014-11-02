class AddVideoUrlToTutorials < ActiveRecord::Migration
  def change
  	add_column :tutorials, :video_url
  end
end
