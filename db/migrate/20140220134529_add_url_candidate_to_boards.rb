class AddUrlCandidateToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :url_candidate, :string
  end
end
