class RemoveUsernameFromHackers < ActiveRecord::Migration
  def up
    remove_column :hackers, :username
      end

  def down
    add_column :hackers, :username, :string
  end
end
