class AddReviewUrlToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :review_url, :string
    add_column :beautyclasses, :supply, :string
    add_column :beautyclasses, :price, :integer
  end
end
