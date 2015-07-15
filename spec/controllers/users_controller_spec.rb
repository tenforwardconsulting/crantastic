require 'rails_helper'

include AuthHelper

RSpec.describe UsersController do

  render_views

  it "should render the index successfully" do
    get :index
    expect(response).to render_template(:index)
  end

  it "should have a atom feed for user activity" do
    expect(User).to receive(:find).twice.with("2").and_return(stub_model(User))
    get :show, :id => "2", :format => "atom"
    expect(response.status).to eq(200)
  end

  it "should do a 404 for unknown users" do
    get :show, :id => 9999
    expect(response.status).to eq(404)
  end

  it "should render the signup page successfully" do
    get :new
    expect(response).to render_template(:new)
    expect(response).not_to be_redirect
  end

  it "should require no user for the signup page" do
    login_as_user
    get :new
    expect(response).not_to render_template(:new)
    expect(response).to be_redirect
  end

  it "should require no user for the thanks page" do
    login_as_user
    get :thanks
    expect(response).to be_redirect
  end

  describe "edit/update" do

    it "should require login for the edit page" do
      get :edit, :id => "74"
      expect(response).to be_redirect
    end

    it "should not let users edit other users profiles" do
      login_as_user(:id => 1)
      expect(User).to receive(:find).with("2").and_return(stub_model(User))
      get :edit, :id => "2"
      expect(response.status).to eq(403)
    end

    it "should not let users update other users profiles" do
      login_as_user(:id => 1)
      expect(User).to receive(:find).with("2").and_return(stub_model(User))
      put :update, :id => "2"
      expect(response.status).to eq(403)
    end

  end

  describe "#regenerate_api_key" do

    it "should require login" do
      post :regenerate_api_key, :id => "2"
      expect(response).to be_redirect
    end

  end

end
