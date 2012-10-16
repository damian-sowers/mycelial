class AddProjectIdToTagowners < ActiveRecord::Migration
  def change
    add_column :tagowners, :project_id, :integer
    add_column :tagowners, :tech_tag_id, :integer
  end
end
