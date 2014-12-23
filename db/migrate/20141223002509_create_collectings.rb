class CreateCollectings < ActiveRecord::Migration
  def change
    create_table :collectings do |t|
		t.belongs_to :collection
		t.belongs_to :collectable, polymorphic: true

		t.timestamps
    end
    add_index :collectings, [:collectable_id, :collectable_type]
  end
end
