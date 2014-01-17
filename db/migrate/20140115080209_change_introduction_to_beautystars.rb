class ChangeIntroductionToBeautystars < ActiveRecord::Migration
  def up
  	change_column :beautystars, :introduction, :text
  end

  def down
  	change_column :beautystars, :introduction, :string
  end
end
