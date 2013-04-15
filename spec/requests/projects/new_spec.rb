require "spec_helper.rb"

describe "new project" do
  let(:user) { FactoryGirl.create(:user) }
  subject { page }
  before do
    sign_in(user)
  end

  describe "user clicks 'add a new project'" do
    before do 
      visit edit_page_path(user)
      click_link "Add a new project"
    end
    
    it { should have_selector('a', :text => "Programming Project") }
    it { should have_selector('a', :text => "Blog Post or Article") }
    it { should have_selector('a', :text => "Other") }

    it "should redirec to to new project form" do
      click_link "Programming Project"
      should have_content("Add a new project to your page") 
    end

    describe "user fills in new project form with valid information" do
      before do
        visit new_project_path(:project_type => 1)
        fill_in "Project name", with: "Test Project"
        fill_in "Short description", with: "A little Text"
        fill_in "Long Description", with: "More text"
        # fill_in "Main Languages and Technologies (e.g Ruby, Rails, Python)", with: "rails" -- need to figure out how to test
        fill_in "Other interesting things about this project", with: "some stuff"
        fill_in "Project URL", with: "http://www.google.com"
        fill_in "Github Repo", with: "http://www.github.com/damian-sowers/mycelial"
        # attach_file 'Upload a Picture', "#{Rails.root}/spec/fixtures/images/code.png"
        click_button "Submit"
      end

      it "should redirect user to show page" do
        current_path.should == page_path(user.username)
      end
      it { should have_content("Projects") } 
      it { should have_content("Test Project") } 
    end

    describe "user fills in new project form with invalid information" do
      before do
        visit new_project_path(:project_type => 1)
        fill_in "Project name", with: " "
        fill_in "Short description", with: "A"*501
        fill_in "Long Description", with: "More text"
        # fill_in "Main Languages and Technologies (e.g Ruby, Rails, Python)", with: "rails"
        fill_in "Other interesting things about this project", with: "some stuff"
        fill_in "Project URL", with: "http://www.google.com"
        fill_in "Github Repo", with: "http://www.github.com/damian-sowers/mycelial"
        # attach_file 'Upload a Picture', "#{Rails.root}/spec/fixtures/images/code.png"
        click_button "Submit"
      end

      it "should redirect user to show page" do
        current_path.should_not == page_path(user.username)
      end
      it { should have_content("can't be blank") } 
    end
  end
end