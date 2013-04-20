require 'spec_helper'

describe Notification do
  let(:notification) { create(:notification) }
  let(:sender) { create(:user) }
  let(:receiver) { create(:user, username: 'other', email: 'other@other.com') }
  let(:page) { create(:page, user_id: receiver.id) }
  let(:project) { create(:project, page_id: page.id) }

  it { should respond_to :sender_id }
  it { should respond_to :receiver_id }
  it { should respond_to :notification_type }
  it { should respond_to :notification_id }

  describe "::get_new_notifications" do
    before do
      # Notification creation triggered after comment/like creation
      Comment.create(project_id: project.id, user_id: sender.id)
    end

    it "returns unread notifications for a user" do
    notification = Notification.get_new_notifications(receiver.id)[0]
      notification.viewed.should eq 0
    end
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

