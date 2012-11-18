class AddViewedToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :viewed, :integer
  end
end
