class AddUsernameToHackers < ActiveRecord::Migration
  def change
    add_column :hackers, :username, :string
  end
end
