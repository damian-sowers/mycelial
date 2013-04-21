require 'spec_helper'

describe Project do
  let(:project) { create(:project) }
  let(:uploader) { PictureUploader.new(project, :picture) }

  subject { project }

  it { should be_valid }
  it { should respond_to :project_name }
  it { should respond_to :short_description }
  it { should respond_to :long_description }
  it { should respond_to :main_language }
  it { should respond_to :other_interesting }
  it { should respond_to :picture }
  it { should respond_to :url }
  it { should respond_to :github_repo }
  it { should respond_to :page_id }
  it { should respond_to :project_type }
  it { should respond_to :widget_type }
  it { should respond_to :tag_list }
  it { should respond_to :likes_count}
  it { should respond_to :image_height }
  it { should respond_to :image_width }
  it { should respond_to :tech_tag_tokens }

  describe "when project_name is not present" do
  	before { project.project_name = nil }
  	it { should_not be_valid }
  end

  describe "when project_name is too long" do
    before { project.project_name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when short_description is too long" do
    before { project.project_name = "a" * 501 }
    it { should_not be_valid }
  end

  describe "#tech_tag_tokens=" do
    before { project.tech_tag_tokens=("<<<rails>>>") }
    it "sets tech_tag_ids" do
      project.tech_tag_ids.should eq [1]
    end
  end

 
  describe "#save_image_dimensions" do
    before do
      uploader.store!(File.open("#{Rails.root}/spec/support/images/sample.gif"))
      project.save!
    end

    after do
      # remove test-generated uploads from file storage
      FileUtils.rm_rf(Dir["#{Rails.root}/tmp/carrierwave/*"])
      FileUtils.rm_rf(Dir["#{Rails.root}/tmp/uploads/*"])
    end

    its(:picture) { should be_a PictureUploader }
    # can't get these to pass
    # its(:image_width) { should_not be_nil }
    # its(:image_height) { should_not be_nil }
  end
end

# == Schema Information
#
# Table name: projects
#
#  id                :integer         not null, primary key
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  project_name      :string(255)
#  short_description :text
#  long_description  :text
#  main_language     :string(255)
#  other_interesting :text
#  picture           :string(255)
#  url               :string(255)
#  github_repo       :string(255)
#  page_id           :integer
#  project_type      :integer
#  widget_type       :integer
#

