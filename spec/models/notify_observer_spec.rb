require 'spec_helper'

describe NotifyObserver do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user, username: 'other', email: 'other@other.com') }
  let(:page) { create(:page, user_id: receiver.id) }
  let(:project) { create(:project, page_id: page.id) }

  describe "#after_create" do
    context "when model is a Like" do
      before do
        # Trigger observer
        Like.create(user_id: sender.id, project_id: project.id)
      end

      it "creates a new Notification" do
        Notification.count.should eq 1
      end

      it "increments the associated project's likes_count" do
        project.reload
        project.likes_count.should eq 1
      end

      it "sets the notification_type to 'like'" do
        Notification.first.notification_type.should eq 'like'
      end
    end

    context "when model is a Comment" do
      before do
        # Trigger observer
        Comment.create(project_id: project.id, user_id: sender.id)
      end

      it "creates a new Notification" do
        Notification.count.should eq 1
      end

      it "sets the notification_type to 'comment'" do
        Notification.first.notification_type.should eq 'comment'
      end
    end
  end

  describe "#increment_likes_count" do
    before do
     Like.create(user_id: sender.id, project_id: project.id)
     project.reload
    end

    it "increments the associated project's likes_count" do
      project.likes_count.should eq 1
    end
  end

  describe "#decrement_likes_count" do
    before do
      like = Like.create(user_id: sender.id, project_id: project.id)
      project.reload
      like.destroy; project.reload
    end

    it "decrements the associated project's likes_count" do
      project.likes_count.should eq 0
    end
  end
end
