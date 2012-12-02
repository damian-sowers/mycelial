class AddImageWidthToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :image_width, :integer
    add_column :projects, :image_height, :integer
  end
end
