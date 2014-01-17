class AddSlugToBeautystars < ActiveRecord::Migration
  def change
    add_column :beautystars, :slug, :string
    add_index :beautystars, :slug
  end
end
