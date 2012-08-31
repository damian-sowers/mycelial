class CreateHackers < ActiveRecord::Migration
  def change
    create_table :hackers do |t|

      t.timestamps
    end
  end
end
