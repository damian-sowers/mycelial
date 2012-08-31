class AddNameToHacker < ActiveRecord::Migration
  def change
    add_column :hackers, :name, :string
  end
end
