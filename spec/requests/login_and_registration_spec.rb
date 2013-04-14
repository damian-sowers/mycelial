require 'spec_helper'

describe "user login, logout, and registration" do 

  subject { page }
  let(:user) { FactoryGirl.create(:user) }

  describe "new user registration" do
    before { visit new_user_registration_path }
    let(:submit) { "Sign up" }

    describe "with invalid information" do
      it "should not create a new user" do
        expect { click_button submit }.not_to change(User, :count)
        should have_content("can't be blank") #using client side validations gem, so the text will be returned after they type if there is an error. 
      end
    end

    describe "with valid information" do
      before do 
        fill_in "user_username", with: "dsowers"
        fill_in "user_email", with: "example@example.com"
        fill_in "user_password", with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end

      it "should creat a user" do
        expect { click_button submit}.to change(User, :count).by(1)
        current_path.should == page_path("dsowers")
      end
    end
  end

  describe "user login" do
    before { visit new_user_session_path }
    let(:submit) { "Sign in" }

    describe "with invalid information" do
      before { click_button submit }

      it { should have_content "Invalid" }
    end

    describe "with valid information" do
      
      before do
        fill_in "user_email",    with: user.email
        fill_in "user_password", with: user.password
        click_button submit
      end

      it "should rediret them to profile page" do
        current_path.should == page_path("dsowers")
        should have_link('Logout') 
      end
    end
  end

  describe "user logout" do 

    before do
      visit new_user_session_path
      fill_in "user_email",    with: user.email
      fill_in "user_password", with: user.password
      click_button "Sign in"
    end

    it "should log them out" do
      click_link "Logout"
      current_path.should == root_path
      should have_selector('a', text: "Login")
    end
  end
end