class RenameOtherTechnologies < ActiveRecord::Migration
  def up
  	rename_column :projects, :other_technologies, :other_interesting
  end

  def down
  	rename_column :projects, :other_interesting, :other_technologies
  end
end
