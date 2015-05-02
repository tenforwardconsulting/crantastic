require 'spec_helper'

describe "search/show.html.haml" do
  before(:each) do
  end

  it "should let the user know if there were no search results" do
    assigns[:results] = []
    render
    expect(rendered).to have_tag('h1', %r[Search])
    expect(rendered).to have_tag('p', %r[no results were found])
  end
end
