require 'spec_helper'

describe "reviews/show.html.haml" do
  let(:review) { FactoryGirl.create(:review, cached_rating: 4) }

  before(:each) do
    allow(view).to receive(:logged_in?) { false }
    assign :review, review
  end

  it "should display a review with rating" do
    render
    expect(rendered).to have_tag('h1', /A review of #{review.package}/)
    expect(rendered).to have_tag('p.rating', "4")
    expect(rendered).to have_tag('strong', review.title)
  end

end
