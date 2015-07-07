require 'spec_helper'

describe VersionsController do

  before(:each) do
    create :version, package: create(:package, name: 'rJython')
  end

  render_views

  it "should have an atom feed" do
    get :feed, :format => "atom"
    expect(response.body).to include("New package versions on crantastic")
    expect(response).to be_success
  end

end
