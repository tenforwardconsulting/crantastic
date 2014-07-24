require 'spec_helper'

describe VotesController do

  before(:each) do
    create(:user).activate
    @user = User.first
  end

  it "should be redirected if the token for the create action is invalid" do
    post :create, :user_credentials => "invalid"
    response.should be_redirect
  end

  it "should create new package votes" do
    ggplot = create :package, name: 'ggplot'
    rjson  = create :package, name: 'rjson'
    post :create, :packages => "ggplot,rjson", :user_credentials => @user.single_access_token
    response.should_not be_redirect
    response.status.should == 200
    PackageUser.count.should == 2
    @user.reload
    @user.uses?(ggplot).should be_true
    @user.uses?(rjson).should be_true
  end

end
