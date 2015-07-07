require 'rails_helper'

RSpec.describe "/authors/index.html.erb" do

  it "should display the number of package maintainers" do
    assign(:authors, FactoryGirl.build_list(:author, 2))
    render
    expect(rendered).to have_tag('p', %r[There are 2 package maintainers on crantastic])
  end

end
