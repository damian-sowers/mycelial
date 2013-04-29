require 'spec_helper'

describe Page do
  
  let(:page) { create(:page) }

  subject { page }

  it { should be_valid }
  it { should respond_to :name }
  it { should respond_to :hnusername }
  it { should respond_to :linkedin_username }
  it { should respond_to :personal_site }
  it { should respond_to :github_username }
  it { should respond_to :user_id }
  it { should respond_to :about_text }
  it { should respond_to :image }
  it { should respond_to :crop_x }
  it { should respond_to :crop_y }
  it { should respond_to :crop_w }
  it { should respond_to :crop_h }
  it { should respond_to :new_user }

  describe "when name is not present" do
    before { page.name = nil }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { page.name = "a" }
    it { should_not be_valid } 
  end

  describe "when name is too long" do
    before { page.name = "a" * 31 }
    it { should_not be_valid }
  end
end

# == Schema Information
#
# Table name: pages
#
#  id                :integer         not null, primary key
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  name              :string(255)
#  hnusername        :string(255)
#  linkedin_username :string(255)
#  personal_site     :string(255)
#  github_username   :string(255)
#  user_id           :integer
#  about_text        :text
#  image             :string(255)
#
