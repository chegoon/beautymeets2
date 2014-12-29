class AddPublishedtoCollections < ActiveRecord::Migration
  def up
  	add_column :collections, :published, :boolean
  	add_column :collections, :slug, :string
  	add_column :collections, :url_candidate, :string
  end

  def down
  	remove_column :collections, :published
  	remove_column :collections, :slug
  	remove_column :collections, :url_candidate
  end
end
