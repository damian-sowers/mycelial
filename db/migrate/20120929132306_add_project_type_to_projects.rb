class AddProjectTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_type, :integer
    add_column :projects, :widget_type, :integer
  end
end
