require 'rails_helper'

include AuthHelper

RSpec.describe TagsController do

  before(:each) do
    @tag = FactoryGirl.create :tag
  end

  it "should render the index successfully" do
    get :index
    expect(response).to be_success
    expect(response).to render_template(:index)
  end

  it "should have a atom feed for tag activity" do
    get :show, :id => @tag.name, :format => "atom"
    expect(response.status).to eq(200)
  end

end
