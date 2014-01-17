class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.belongs_to :user
      t.belongs_to :bookmarkable, polymorphic: true
      t.text :note

      t.timestamps
    end
  end
end
