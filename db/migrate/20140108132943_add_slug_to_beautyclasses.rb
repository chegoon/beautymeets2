class AddSlugToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :slug, :string
    add_index :beautyclasses, :slug
  end
end
