class RenameBoyToMembers < ActiveRecord::Migration
  def up
  	rename_column :members, :birth_of_year, :year_of_birth
  end

  def down
  	rename_column :members, :year_of_birth, :birth_of_year
  end
end
