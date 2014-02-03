class CreateBookmarkTypes < ActiveRecord::Migration
  def change
    create_table :bookmark_types do |t|
      t.string :model

      t.timestamps
    end
  end
end
