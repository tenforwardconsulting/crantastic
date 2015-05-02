require 'spec_helper'

include AuthHelper

describe PackagesController do

  before(:each) do
    create :version, package: create(:package, name: 'rJython')
    create :version, package: create(:package, name: 'data.table')
  end

  render_views

  it "should render the index successfully" do
    get :index
    expect(response).to render_template(:index)
  end

  it "should do a 301 for numerical package ids" do
    get :show, :id => Package.find_by_name("rJython").id.to_s
    expect(response).to redirect_to("/packages/rJython")
    expect(response.status).to eq(301)
  end

  it "should do a 301 if package name differs in case from id" do
    get :show, :id => "rjython"
    expect(response).to redirect_to("/packages/rJython")
    expect(response.status).to eq(301)
  end

  it "should not incorrectly 301 for package names with dots" do
    get :show, :id => "data-table"
    expect(response.status).to eq(200)
  end

  it "should do a 404 for unknown packages" do
    get :show, :id => "blabla"
    expect(response.status).to eq(404)
    expect(response).to_not be_redirect
  end

  describe 'POST toggle_usage' do
    context 'with a logged out user' do
      it "should redirect if not logged in" do
        post :toggle_usage, :id => "aaMI"
        expect(response).to be_redirect
      end
    end

    context 'with a logged in user' do
      it "should be possible to toggle package usage" do
        login_as_user(:id => 1, :login => "test")

        package = FactoryGirl.create(:package, :name => 'aaMI')
        controller.instance_eval do
          current_user.should_receive(:toggle_usage).with(package).and_return(true)
        end

        post :toggle_usage, :id => package.name

        expect(flash[:notice]).to eq("Thanks!")
        expect(response).to be_redirect
      end
    end
  end

  describe 'GET feed' do
    it "renders the feed template" do
      get :feed, :format => "atom"
      expect(response).to be_success
      expect(response).to render_template("packages/feed")
    end
  end

  describe "Routes" do

    it "should have route helper for package usage toggle" do
      toggle_usage_package_path(Package.new(:name => "aaMI")).should ==
        "/packages/aaMI/toggle_usage"
    end

  end

  describe "XHTML Markup" do
    before { skip "skip broken tests for valid xhtml" }

    it "should be valid for the index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the show page" do
      get :show, :id => Package.first.to_param
      response.body.strip_entities.should be_xhtml_strict
    end

    it "should be valid for the all page" do
      get :all
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
