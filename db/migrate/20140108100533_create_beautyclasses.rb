class CreateBeautyclasses < ActiveRecord::Migration
  def change
    create_table :beautyclasses do |t|
      t.string :title
      t.text :description
      t.integer :view_count, :default => 0
      t.integer :capacity
      t.boolean :soldout, :default => false
      t.boolean :published, :default => false

      t.timestamps
    end
  end
end
