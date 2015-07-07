require 'rails_helper'

RSpec.describe "Tags" do
  let!(:user) { FactoryGirl.create(:user, :login => "john", :password => 'password') }


  before(:each) do
    FactoryGirl.create :version
    user.activate
    visit package_url(Package.first)
    click_on "Add tags"
  end

  it "should add tags to a package" do
    expect(page.current_path).to eq login_path
    login_with_valid_credentials(user.login, user.password)
    expect(page.current_path).to eq new_package_tagging_path(Package.first)

    fill_in "tag_name", :with => "test"
    click_button "Tag it!"

    expect(page.current_path).to eq package_path(Package.first)
    expect(page).to have_selector("li", "test")
    expect(page).to have_content "Add tags"
  end

  describe "as a logged in user" do
    before(:each) do
      login_with_valid_credentials(user.login, user.password)
    end

    it "should add multiple tags to a package" do
      fill_in "tag_name", :with => "MachineLearning, NLP"
      click_button "Tag it!"

      expect(page.current_path).to eq package_path(Package.first)
      expect(page).to have_selector("li", "MachineLearning")
      expect(page).to have_selector("li", "NLP")
      expect(page).to have_content "Add tags"
    end
  end
end
