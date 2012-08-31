class AddUserIdToHacker < ActiveRecord::Migration
  def change
    add_column :hackers, :user_id, :integer
  end
end
