require 'rails_helper'

RSpec.describe PackageUser do

  before(:each) do
    FactoryGirl.create :package
    FactoryGirl.create :user
  end

  it "should have a counter cache for the number of votes" do
    p = Package.first
    expect(p.package_users_count).to eq(0)
    p.package_users << PackageUser.new(:user => User.first)
    p.reload
    expect(p.package_users_count).to eq(1)
  end

end
