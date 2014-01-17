class AddDatesToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :start_date, :datetime
    add_column :beautyclasses, :end_date, :datetime
  end
end
