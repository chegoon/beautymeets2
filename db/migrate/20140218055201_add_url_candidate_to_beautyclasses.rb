class AddUrlCandidateToBeautyclasses < ActiveRecord::Migration
  def change
    add_column :beautyclasses, :url_candidate, :string
  end
end
