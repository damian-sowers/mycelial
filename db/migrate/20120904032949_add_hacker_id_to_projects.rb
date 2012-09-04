class AddHackerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :hacker_id, :integer
  end
end
