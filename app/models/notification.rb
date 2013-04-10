class Notification < ActiveRecord::Base
  attr_accessible :sender_id, :receiver_id, :notification_id, :notification_type
  
  belongs_to :user, :foreign_key => :receiver_id

  def self.get_new_notifications(receiver_id)
    new_notifications = self.where("receiver_id = ? AND viewed = 0", receiver_id)
  end
end
# == Schema Information
#
# Table name: notifications
#
#  id                :integer         not null, primary key
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  sender_id         :integer
#  receiver_id       :integer
#  notification_id   :integer
#  notification_type :string(255)
#  viewed            :integer
#

