require 'spec_helper'

describe "Static Pages" do 
  
  describe "Home page" do
    it "should have the content 'project'" do
      visit '/'
      page.should have_content('project')
      page.should have_selector('b',  :text => "One portfolio to rule them all")
    end
  end

  describe "About page" do 
    it "should have the content ''Mycelial is a better way to promote your work.'" do
      visit '/home/about'
      page.should have_content('Mycelial is a better way to promote your work')
    end
  end

  describe "terms page" do 
    it "should have the content 'Terms and Conditions'" do
      visit '/home/terms' 
      page.should have_content('Terms and Conditions')
    end
  end
end