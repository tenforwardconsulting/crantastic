require 'spec_helper'

feature "Authentication" do

  it "should sign up users with valid credentials" do
    visit signup_url
    fill_in "User name", :with => "john"
    fill_in "Email", :with => "test@test.com"
    fill_in "Password", :with => "test"
    fill_in "Confirm password", :with => "test"
    check "user_tos"
    UserMailer.should_receive(:deliver_activation_instructions)
    click_button "Sign up"
    expect(page).to have_content "Thanks for signing up."
    expect(page.current_path).to eq thanks_path
  end

  it "should not login the user before activation" do
    create :user, login: 'john'
    login_with_valid_credentials
    expect(page).to have_content "Invalid user name or password."
  end

  it "should be possible for the user to activate his account" do
    UserMailer.should_receive(:deliver_activation_confirmation)
    visit activate_url(create(:user).perishable_token)
    expect(page).to have_content "Signup complete! You're now logged in and can start reviewing and tagging."
  end

  it "should not login an user with invalid credentials" do
    visit login_url
    fill_in "login", :with => "john"
    fill_in "password", :with => "invalid"
    click_button "login"
    expect(page).to have_content "Invalid user name or password. Maybe you meant to sign up instead?"
  end

  describe "activated user" do
    before(:each) do
      create(:user, login: 'john').activate
      create :version
    end

    it "should login an activated user with valid credentials" do
      login_with_valid_credentials
      assert_contain "Logged in successfully"
      response.should have_selector("h1", "john")
      response.should have_selector("a", "Edit your details")
    end

    it "should redirect to the intended page after login" do
      visit package_path(Package.first)
      click_link "Write one now"
      expect(page.current_path).to eq login_path
      login_with_valid_credentials
      expect(page.current_page).to eq new_package_review_path(Package.first)
    end

    it "should redirect to root url after logging out" do
      login_with_valid_credentials
      expect(page.current_path).to eq user_path(User.first)
      click_link "Log out"
      expect(page).to have_content "You have been logged out."
      expect(page.current_path).to eq root_path
    end
  end
end
