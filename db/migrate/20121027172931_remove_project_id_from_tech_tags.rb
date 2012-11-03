class RemoveProjectIdFromTechTags < ActiveRecord::Migration
  def up
    remove_column :tech_tags, :project_id
  end

  def down
    add_column :tech_tags, :project_id, :integer
  end
end
