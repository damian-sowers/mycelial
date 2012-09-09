class AddImageToHackers < ActiveRecord::Migration
  def change
    add_column :hackers, :image, :string
  end
end
