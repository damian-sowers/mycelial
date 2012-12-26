class AddPageOrderToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :page_order, :integer
  end
end
