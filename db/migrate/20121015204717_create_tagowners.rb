class CreateTagowners < ActiveRecord::Migration
  def change
    create_table :tagowners do |t|

      t.timestamps
    end
  end
end
