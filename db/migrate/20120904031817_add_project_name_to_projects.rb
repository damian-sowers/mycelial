class AddProjectNameToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_name, :string
    add_column :projects, :short_description, :text
    add_column :projects, :long_description, :text
    add_column :projects, :main_language, :string
    add_column :projects, :other_technologies, :text
    add_column :projects, :picture, :string
    add_column :projects, :url, :string
    add_column :projects, :github_repo, :string
  end
end
