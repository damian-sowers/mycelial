require 'spec_helper'

describe BetaInvite do
  let(:invite) { create(:beta_invite) }

  subject { invite }

  it { should be_valid }
  it { should respond_to :email }
  
  describe "when email is not present" do
  	before { invite.email = nil }
  	it { should_not be_valid }
  end

  describe "when email is not unique" do
    it "is not valid" do
      invite = create(:beta_invite)
      dup_invite = build(:beta_invite)
      dup_invite.should_not be_valid
    end
  end

  describe "case sensitivity" do
    it "is not case sensitive" do
      invite = create(:beta_invite)
      dup_invite = build(:beta_invite, email: "EXAMPLE@EXAMPLE.COM")
      dup_invite.should_not be_valid
    end
  end
end
