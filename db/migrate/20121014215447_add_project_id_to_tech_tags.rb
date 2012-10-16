class AddProjectIdToTechTags < ActiveRecord::Migration
  def change
    add_column :tech_tags, :project_id, :integer
  end
end
