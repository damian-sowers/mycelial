class AddHnusernameToHacker < ActiveRecord::Migration
  def change
    add_column :hackers, :hnusername, :string
    add_column :hackers, :linkedin_username, :string
    add_column :hackers, :personal_site, :string
    add_column :hackers, :github_username, :string
  end
end
