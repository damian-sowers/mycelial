require "spec_helper"

describe Welcome do

  let(:user) { create :user }
  let(:sent) { ActionMailer::Base.deliveries }

  describe "#send_welcome_email" do
    before { Welcome.send_welcome_email(user.email).deliver }

    it "delivers mail" do
      sent.should_not be_empty
    end

    it "sends the correct message" do
      email = sent.last
      email.subject.should eq "Damian from Mycelial. Thanks for trying it out!"
    end
  end
end
