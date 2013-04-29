require "spec_helper"

describe NotificationMailer do
  
  let(:user) { create :user }
  let(:receiver) { create :user, email: "receiver@example.com", username: "other" }
  let(:comment) { create :comment, user_id: user.id, username: user.username, project_id: project.id }
  let(:like) { create :like, user_id: user.id, username: user.username, project_id: project.id }
  let(:page) { create(:page, user_id: receiver.id) }
  let(:project) { create(:project, page_id: page.id) }
  let(:sent) { ActionMailer::Base.deliveries }

  describe "#send_like_notification" do
    before { NotificationMailer.send_like_notification(like, receiver.email).deliver }

    it "delivers mail" do
      sent.should_not be_empty
    end

    it "sends the correct message" do
      email = sent.last
      email.subject.should eq "#{like.username} just liked your project on Mycelial"
    end
  end

  describe "#send_comment_notification" do
    before { NotificationMailer.send_comment_notification(comment, receiver.email).deliver }
    
    it "delivers mail" do
      sent.should_not be_empty	
    end

    it "sends the correct message" do
      email = sent.last
      email.subject.should eq "#{comment.username} just commented on your project"
    end
  end
end
