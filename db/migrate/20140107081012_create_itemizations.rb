class CreateItemizations < ActiveRecord::Migration
  def change
    create_table :itemizations do |t|
      t.belongs_to :item
  		t.belongs_to :itemizable, polymorphic: true

      t.timestamps
    end
    add_index :itemizations, [:itemizable_id, :itemizable_type]
  end
end
