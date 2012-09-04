class AddProjectTitleToHackers < ActiveRecord::Migration
  def change
  	add_column :hackers, :project_title, :string
  end
end
