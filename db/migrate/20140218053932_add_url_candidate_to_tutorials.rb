class AddUrlCandidateToTutorials < ActiveRecord::Migration
  def change
    add_column :tutorials, :url_candidate, :string
  end
end
