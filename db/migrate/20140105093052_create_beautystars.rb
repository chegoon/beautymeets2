class CreateBeautystars < ActiveRecord::Migration
  def change
    create_table :beautystars do |t|
      t.string :introduction
      t.string :fullname
      t.string :view_count
      t.string :job_title
      t.string :vimeo_url


      t.timestamps
    end

  end
end
