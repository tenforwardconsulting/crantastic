require 'spec_helper'

describe PackagesHelper do

  before(:each) do
    @pkg = Package.new
  end

  describe "rating helper" do

    it "should return blank if no ratings" do
      allow(@pkg).to receive(:rating_count).and_return(0)
      expect(helper.rating(@pkg)).to eq("")
    end

    it "should return the avg if there are ratings" do
      allow(@pkg).to receive(:rating_count).and_return(2)
      allow(@pkg).to receive(:average_rating).and_return(4)
      expect(helper.rating(@pkg)).to eq("4.0/5")
    end

  end

end
