require 'rails_helper'

RSpec.describe TimelineEventsController do

  before(:each) do
    FactoryGirl.create :timeline_event_for_version
  end

  render_views

  it "should set the page title" do
    get :index
    expect(response.body).to include("It's crantastic!")
    expect(response).to be_success
  end

  it "should have an atom feed" do
    get :index, :format => "atom"
    expect(response.body).to include("Latest activity on crantastic")
    expect(response).to be_success
  end

  describe "XHTML Markup" do
     before { skip "broken markup validity specs" }

    it "should be valid for the index page" do
      get :index
      expect(response.body.strip_entities).to be_xhtml_strict
    end

  end

end
