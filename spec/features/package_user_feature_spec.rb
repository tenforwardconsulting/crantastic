require 'spec_helper'

describe "Package users" do
  let!(:user) { create(:user, login: 'john', password: "test") }
  let!(:version) { create(:version) }
  let!(:package) { version.package }


  before(:each) do
    user.activate
    user.package_users.destroy_all
    visit login_path
    login_with_valid_credentials(user.login, user.password)
    visit package_url(package)
  end

  it "should be possible to vote for a package" do
    click_on "I use this!"
    expect(page).to have_selector 'span', '1 user'
    expect(page).to have_selector 'div.flash'
    expect(page.current_path).to eq package_path(package)
  end

end
