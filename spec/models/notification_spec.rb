require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
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

