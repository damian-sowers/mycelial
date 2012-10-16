class CreateTechTags < ActiveRecord::Migration
  def change
    create_table :tech_tags do |t|

      t.timestamps
    end
  end
end
