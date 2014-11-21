class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|
      t.string :title
      t.string :body
      t.boolean :sent

      t.timestamps
    end
  end
end
