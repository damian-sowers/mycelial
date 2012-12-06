class ChangeProjects < ActiveRecord::Migration
  def up
  	change_column :projects, :likes_count, :integer, :default => 0
  end

  def down
  	change_column :projects, :likes_count, :integer
  end
end
