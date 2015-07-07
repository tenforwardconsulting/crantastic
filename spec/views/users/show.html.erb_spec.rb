require 'spec_helper'

describe "/users/show.html.erb" do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user) { user }
    assign :user, user
    assign :events, []
  end

  it "should display a blank user profile" do
    render
    expect(rendered).to have_tag('p', "#{user} hasn't written any reviews yet.")
    expect(rendered).to have_tag('p', "#{user} hasn't tagged any packages yet.")
  end

  it "should display the user's homepage" do
    user.homepage = "http://crantastic.org"
    render
    expect(rendered).to have_tag('span.homepage') do
      with_tag('a', 'http://crantastic.org')
    end
  end

  it "should not display the homepage link for the default url" do
    user.homepage = "http://"
    render
    expect(rendered).to_not have_tag('a', 'http://')

  end

  it "should display the user's reviews" do
    ver = FactoryGirl.create(:version)
    FactoryGirl.create(:review, :user => user, :cached_rating => 3, :package => ver.package,
                :version => ver)
    FactoryGirl.create(:review, :user => user, :cached_rating => nil)
    FactoryGirl.create(:review, :user => user, :cached_rating => nil,
                :version => ver, :package => ver.package)

    render
    expect(rendered).to have_tag('p', "#{user} has written 3 reviews:")
    expect(rendered).to have_tag('ul') do
      with_tag('li', /gave .* a 3, and[\n ]* says/)
      with_tag('li', /did not rate .*, but[\n ]* says/)
      # Version should be displayed in parentheses when set
      with_tag('li', /did not rate .* \(#{ver}\).*, but[\n ]* says/)
    end
  end

  it "should display the user's taggings" do
    FactoryGirl.create :tagging_of_package, :user => user
    user.reload
    assign :user, user
    render
    expect(rendered).to have_tag('h2', "Tags")
    expect(rendered).to have_tag('p', "#{user} has tagged 1 package:")
    expect(rendered).to have_tag('ul') do
      with_tag('li', /with [a-zA-Z]*:/)
    end
  end

end
