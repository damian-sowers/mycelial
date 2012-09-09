class AddAboutTextToHackers < ActiveRecord::Migration
  def change
    add_column :hackers, :about_text, :text
  end
end
