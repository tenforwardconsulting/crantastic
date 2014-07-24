require 'spec_helper'

describe VersionsController do

  before(:each) do
    create :version, package: create(:package, name: 'rJython')
  end

  render_views

  it "should have an atom feed" do
    get :feed, :format => "atom"
    response.should have_tag('title', "New package versions on crantastic")
    response.should be_success
  end

end
