require 'spec_helper'

describe TimelineEventsController do

  before(:each) do
    make_timeline_event_for_version
  end

  render_views

  it "should set the page title" do
    get :index
    response.should have_tag('title', "It's crantastic!")
    response.should be_success
  end

  it "should have an atom feed" do
    get :index, :format => "atom"
    response.should have_tag('title', "Latest activity on crantastic")
    response.should be_success
  end

  describe "XHTML Markup" do

    it "should be valid for the index page" do
      get :index
      response.body.strip_entities.should be_xhtml_strict
    end

  end

end
