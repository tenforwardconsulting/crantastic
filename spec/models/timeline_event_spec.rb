require 'spec_helper'

describe TimelineEvent do

  #should_validate_presence_of :event_type

  before(:each) do
    create :package_rating
  end

  it "should cache package ratings" do
    event = TimelineEvent.create!(:event_type => "new_package_rating",
                                  :subject => PackageRating.first)
    event.cached_value.should == PackageRating.first.rating.to_s
  end

  it "should cache task view versions" do
    event = create(:task_view).update_version("2009-09-09")
    event.cached_value.should == TaskView.first.version
  end

  it "should know if it is a package event" do
    TimelineEvent.new(:event_type => "new_package").should be_package_event
    TimelineEvent.new(:event_type => "new_version").should be_package_event
    TimelineEvent.new(:event_type => "new_review").should_not be_package_event
  end

end
