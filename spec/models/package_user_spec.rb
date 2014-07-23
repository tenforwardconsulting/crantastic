require 'spec_helper'

describe PackageUser do

  before(:each) do
    create :package
    create :user
  end

  it "should have a counter cache for the number of votes" do
    p = Package.first
    p.package_users_count.should == 0
    p.package_users << PackageUser.new(:user => User.first)
    p.reload
    p.package_users_count.should == 1
  end

end
