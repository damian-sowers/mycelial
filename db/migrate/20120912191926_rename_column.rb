class RenameColumn < ActiveRecord::Migration
  def up
  	rename_column :projects, :hacker_id, :page_id
  end

  def down
  	rename_column :projects, :page_id, :hacker_id
  end
end
