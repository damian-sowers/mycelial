require 'spec_helper'

describe UserObserver do

  describe "#after_create" do
    before { create(:user) }

    it "creates a new Page" do
      Page.count.should eq 1
    end
  end
end
