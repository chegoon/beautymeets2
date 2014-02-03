class AddImageToBeautystars < ActiveRecord::Migration
  def change
    add_column :beautystars, :image, :string
  end
end
