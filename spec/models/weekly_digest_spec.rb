require 'spec_helper'

describe WeeklyDigest do

  before(:each) do
    wd = WeeklyDigest.create
    wd.update_attribute(:created_at, DateTime.parse("30 jul 2009"))
    @digest = WeeklyDigest.first
  end

  it "should have a start date" do
    @digest.start_date.should == Date.parse("27 jul 2009") # Start of the week 31
  end

  it "should have an end date" do
    @digest.end_date.should == Date.parse("2 aug 2009") # End of the week 31
  end

  it "should have a title" do
    @digest.title.should == "Weekly digest for week #31"
  end

  it "should not have an email delivered after creation if there is no packages" do
    WeeklyDigest.first.destroy
    DigestMailer.should_not_receive(:deliver_weekly_digest)
    WeeklyDigest.create
  end

end
