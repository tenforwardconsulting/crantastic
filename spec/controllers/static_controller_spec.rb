require 'spec_helper'

describe StaticController do

  render_views

  it "should set correct title for the about page" do
    get :about
    expect(assigns[:title]).to eq("About")
  end

  describe "XHTML Markup" do
    before { skip "skip broken xhtml markup specs" }

    it "should be valid for the about page" do
      get :about
      expect(response.body.strip_entities).to be_xhtml_strict
    end

    it "should be valid for the error 404 page" do
      get :error_404
      expect(response.body.strip_entities).to be_xhtml_strict
    end

    it "should be valid for the error 500 page" do
      get :error_500
      expect(response.body.strip_entities).to be_xhtml_strict
    end

  end

end
