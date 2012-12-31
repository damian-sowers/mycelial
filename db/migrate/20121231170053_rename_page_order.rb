class RenamePageOrder < ActiveRecord::Migration
  def up
  	rename_column :projects, :page_order, :position
  end

  def down
  	rename_column :projects, :position, :page_order
  end
end
