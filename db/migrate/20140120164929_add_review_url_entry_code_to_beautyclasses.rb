class AddReviewUrlEntryCodeToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :entry_code, :string
  end
end
