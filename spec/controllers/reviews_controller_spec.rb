require 'rails_helper'

include AuthHelper

RSpec.describe ReviewsController do

  before(:each) do
    FactoryGirl.create :version
    FactoryGirl.create :review, package: Package.first
  end

  it "should render the index successfully" do
    expect(Review).to receive(:recent)
    get :index
    expect(response).to render_template(:index)
  end

  it "should redirect to login when attempting to write an review without logging in first" do
    get :new
    expect(response).to be_redirect
    expect(flash[:notice]).to match(/You need to log in to access this page/)
  end

  it "should let logged in users write new reviews" do
    login_as_user(:id => 1, :login => "test")
    get :new, :package_id => Package.first.id
    expect(response).to be_success
  end

  it "should require authentication for editing" do
    get :edit, :id => 1
    expect(response).to be_redirect
  end

  it "should let logged in users edit their own reviews" do
    user = login_as_user(:id => 1, :login => "test")
    expect(Review).to receive(:find).with("1").and_return(mock_model(Review, :user => user,
                                                                         :user_id => user.id))
    get :edit, :id => 1
    expect(response).to be_success
    expect(response).to render_template("edit")
  end

  it "should not let logged in users edit other peoples reviews" do
    user = login_as_user(:id => 1, :login => "test")
    expect(Review).to receive(:find).once.with("1").and_return(mock_model(Review, :user => User.new,
                                                                              :user_id => nil))
    get :edit, :id => 1
    expect(response).not_to be_success
    expect(response.status).to eq(403)
  end

  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    expect(response.status).to eq(404)
  end

  it "should set correct title for review pages" do
    review = Review.first
    get :show, :id => review.id
    expect(assigns[:title]).to eq("#{review.user}'s review of #{review.package}")
  end

  describe "XHTML Markup" do
    before do
      skip "xhtml validation isn't implemented"
    end

    render_views

    before(:each) do
      @review = Review.first
    end

    it "should have an XHTML Strict compilant index page" do
      get :index
      expect(response.body.strip_entities).to be_xhtml_strict
    end

    it "should have an XHTML Strict compilant show page" do
      get :show, :id => @review.id
      expect(response.body.strip_entities).to be_xhtml_strict
    end

  end

end
