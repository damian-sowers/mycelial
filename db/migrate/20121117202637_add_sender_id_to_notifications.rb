class AddSenderIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :sender_id, :integer
    add_column :notifications, :receiver_id, :integer
    add_column :notifications, :notification_id, :integer
    add_column :notifications, :notification_type, :string
  end
end
