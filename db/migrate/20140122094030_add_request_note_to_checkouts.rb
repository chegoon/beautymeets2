class AddRequestNoteToCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :request_note, :string
  end
end
