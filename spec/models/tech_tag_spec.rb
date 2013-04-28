require 'spec_helper'

describe TechTag do
  
  let(:tech_tag) { create(:tech_tag) }

  subject { tech_tag }

  it { should respond_to :name }
  it { should respond_to :picture }

  describe "::tokens" do
    context "when TechTags with a matching name are found" do
      before { create(:tech_tag) }

      it "returns matched TechTags" do
        query = TechTag.tokens("rails")
        query[0].name.should eq "rails"
      end
    end

    context "when matching TechTags are not found" do
      let(:bad_query) { TechTag.tokens("python") }

      it "returns an :id" do
        bad_query[0][:id].should eq "<<<python>>>"
      end

      it "returns a :name" do
        bad_query[0][:name].should eq "New: \"python\""
      end
    end
  end

  describe "::ids_from_tokens" do
    before { @ids = TechTag.ids_from_tokens("<<<ruby>>>") }

    it "creates TechTags from tokens" do
      TechTag.count.should eq 1
    end

    it "assigns TechTag names from tokens" do
      TechTag.first.name.should eq "ruby"
    end

    it "returns an array of TechTag ids" do
      @ids.should eq ["1"]
    end
  end
end

# == Schema Information
#
# Table name: tech_tags
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  name       :string(255)
#  picture    :string(255)
#

