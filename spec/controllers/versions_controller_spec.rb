require 'rails_helper'

RSpec.describe VersionsController do

  before(:each) do
    FactoryGirl.create :version, package: FactoryGirl.create(:package, name: 'rJython')
  end

  render_views

  it "should have an atom feed" do
    get :feed, :format => "atom"
    expect(response.body).to include("New package versions on crantastic")
    expect(response).to be_success
  end

end
