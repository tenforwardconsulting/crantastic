require 'spec_helper'

describe "Package users" do

  include AuthHelper

  before(:each) do
    create :version
    create(:user, login: 'john').activate
  end

  before(:each) do
    @user = User.first
    @user.package_users.destroy_all
    @pkg = Package.first
    visit login_url
    login_with_valid_credentials
    visit package_url(@pkg)
  end

  it "should be possible to vote for a package" do
    click_on "I use this!"
    expect(page).to have_selector 'span', '1 user'
    expect(page).to have_selector 'div.flash'
    expect(page.current_path).to eq package_path(@pkg)
    :wa
  end

end
