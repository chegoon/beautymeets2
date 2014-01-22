class AddImageToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :image, :string
  end
end
