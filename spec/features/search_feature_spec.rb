require 'spec_helper'

describe "Search" do
  it "should show search results" do
    visit root_url
    fill_in "q", :with => "test"

    expect(Package).to receive(:find_by_solr).and_return(nil)
    click_on "Search"

    expect(page).to have_selector "h1", "Search"
    expect(page).to have_content "Sorry, no results were found. Please try another search query."
  end

end
