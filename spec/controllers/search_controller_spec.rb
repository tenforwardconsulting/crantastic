require 'spec_helper'

describe SearchController do

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      expect(response).to be_success
    end
  end
end
