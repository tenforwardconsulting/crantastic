require 'rails_helper'

RSpec.describe AuthorsController do
  let(:version) { FactoryGirl.create :version }
  let(:author) { version.maintainer }

  render_views

  describe 'GET show' do
  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    expect(response.status).to eq(404)
    expect(response).to render_template("static/error_404")
  end

  it "should have a atom feed for author activity" do
    get :show, :id => author.id, :format => "atom"
    expect(response.status).to eq(200)
  end

  it "should set a singular title for the author pages" do
    get :show, :id => author.id
    expect(response.body).to include("#{author.name}. It's crantastic!")
  end

  end

  describe "GET index" do
    it "should pluralize the title" do
      get :index
      expect(response.body).to include("Package Maintainers. They're crantastic!")
    end
  end

  describe "XHTML Markup" do
    before { skip "broken xhtml specs" }

    it "should be valid for the index page" do
      get :index
      expect(response.body.strip_entities).to be_xhtml_strict
    end

    it "should be valid for the show page" do
      get :show, :id => author.id
      expect(response.body.strip_entities).to be_xhtml_strict
    end

  end

end
