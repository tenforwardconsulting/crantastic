require 'rails_helper'

RSpec.describe "/timeline_events/show.html.erb" do

  before(:each) do
    assign :event, FactoryGirl.build_stubbed(:timeline_event)
  end

  it "should have a title" do
    render
    expect(rendered).to have_tag('h1', %r[Recent Activity])
  end

end
