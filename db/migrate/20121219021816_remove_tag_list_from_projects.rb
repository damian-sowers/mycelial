class RemoveTagListFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :tag_list
  end

  def down
    add_column :projects, :tag_list, :string
  end
end
