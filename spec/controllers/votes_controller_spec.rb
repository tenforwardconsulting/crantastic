require 'rails_helper'

RSpec.describe VotesController do

  before(:each) do
    FactoryGirl.create(:user).activate
    @user = User.first
  end

  it "should be redirected if the token for the create action is invalid" do
    post :create, :user_credentials => "invalid"
    expect(response).to be_redirect
  end

  it "should create new package votes" do
    ggplot = FactoryGirl.create :package, name: 'ggplot'
    rjson  = FactoryGirl.create :package, name: 'rjson'
    post :create, :packages => "ggplot,rjson", :user_credentials => @user.single_access_token
    expect(response).not_to be_redirect
    expect(response.status).to eq(200)
    expect(PackageUser.count).to eq(2)
    @user.reload
    expect(@user.uses?(ggplot)).to eq true
    expect(@user.uses?(rjson)).to eq true
  end

end
