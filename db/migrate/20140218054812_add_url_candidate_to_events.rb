class AddUrlCandidateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :url_candidate, :string
  end
end
