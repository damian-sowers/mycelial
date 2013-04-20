require 'spec_helper'

describe User do
  before { @user = User.new(username: "damiansowers", email: "user@example.com", password: "testpassword", password_confirmation: "testpassword") } 

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }

  it { should be_valid }

  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email is not correct" do
    before { @user.email = "damian" }
    it { should_not be_valid }
  end

  describe "when username has illegal chars" do 
    before { @user.username = "damian.sowers" }
    it { should_not be_valid }
  end

  describe "when username is too long" do 
    before { @user.username = "d" * 19 }
    it { should_not be_valid }
  end

  describe "when username is too short" do 
    before { @user.username = "d" * 2 }
    it { should_not be_valid }
  end 

  describe "when password doesn't match confirmation" do
    before { 
      @user.password = "djfhfjd"
      @user.password_confirmation = "jdhfksfj"
    }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "#transform_username_to_lowercase" do
    before do
      @user.username = "UPPERCASE"
      @user.save
    end

    its(:username) { should eq "uppercase" }
  end

  describe "#send_welcome_email" do
    before { create(:user) }

    it "triggers the Welcome mailer" do
      delivery = ActionMailer::Base.deliveries.last
      delivery.subject.should eq "Damian from Mycelial. Thanks for trying it out!"
    end
  end

  describe "#to_param" do
    context "when id is nil" do
      it "returns the user's username" do
        @user.to_param.should eq @user.username
      end
    end

    context "when id exists" do
      before { @user.save }

      it "returns the user's id" do
        @user.to_param.should eq @user.id
      end
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  username               :string(255)
#

