require File.join(File.dirname(__FILE__) + "/../../lib/cran.rb")

describe CRAN::TaskView do

  before(:each) do
    @data = File.read(File.join(File.dirname(__FILE__) + "/data/Bayesian.ctv"))
  end

  it "should parse a ctv file" do
    tv = CRAN::TaskView.new(@data)
    expect(tv.name).to eq("Bayesian")
    expect(tv.topic).to eq("Bayesian Inference")
    expect(tv.version).to eq("2009-06-11")
    expect(tv.packagelist.size).to eq(62)
    expect(tv.packagelist[0]).to eq("AdMit")
    expect(tv.packagelist[1]).to eq("arm")
  end

end


describe CRAN::TaskViews do

  before(:each) do
    @data = File.read(File.join(File.dirname(__FILE__) + "/data/index.html"))
  end

  it "should parse the view list" do
    views = CRAN::TaskViews.new(@data)
    expect(views.size).to eq(24)
    expect(views[0]).to eq("Bayesian")
    expect(views[23]).to eq("TimeSeries")
  end

end
