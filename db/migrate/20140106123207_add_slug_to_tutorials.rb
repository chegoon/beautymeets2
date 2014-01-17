class AddSlugToTutorials < ActiveRecord::Migration
  def change
    add_column :tutorials, :slug, :string
    add_column :tutorials, :duration, :integer
    add_index :tutorials, :slug
  end
end
