require 'spec_helper'

include AuthHelper

describe TagsController do

  before(:each) do
    @tag = create :tag
  end

  it "should render the index successfully" do
    get :index
    response.should be_success
    response.should render_template(:index)
  end

  it "should have a atom feed for tag activity" do
    get :show, :id => @tag.name, :format => "atom"
    response.status.should == 200
  end

end
