class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.belongs_to :category
  		t.belongs_to :categorizable, polymorphic: true

      t.timestamps
    end
    add_index :categorizations, [:categorizable_id, :categorizable_type]
  end
end
