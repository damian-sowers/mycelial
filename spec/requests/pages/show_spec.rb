require 'spec_helper'

describe "user page" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  
  before { visit page_path(user.username) }

  it { should have_selector('a', text: "Projects") }
end