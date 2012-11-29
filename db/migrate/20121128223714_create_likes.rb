class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|

      t.timestamps
    end
    add_column :likes, :user_id, :integer
    add_column :likes, :project_id, :integer
  end
end
