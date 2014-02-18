class AddUrlCandidateToItems < ActiveRecord::Migration
  def change
    add_column :items, :url_candidate, :string
  end
end
