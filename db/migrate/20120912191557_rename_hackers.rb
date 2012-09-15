class RenameHackers < ActiveRecord::Migration
  def up
  	rename_table :hackers, :pages
  end

  def down
  	rename_table :pages, :hackers
  end
end
