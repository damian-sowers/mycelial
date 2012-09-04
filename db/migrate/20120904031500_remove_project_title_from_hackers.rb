class RemoveProjectTitleFromHackers < ActiveRecord::Migration
  def up
    remove_column :hackers, :project_title
      end

  def down
    add_column :hackers, :project_title, :string
  end
end
