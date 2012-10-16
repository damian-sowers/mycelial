class AddNameToTechTags < ActiveRecord::Migration
  def change
    add_column :tech_tags, :name, :string
    add_column :tech_tags, :picture, :string
  end
end
