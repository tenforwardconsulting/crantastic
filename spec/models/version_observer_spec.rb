require 'spec_helper'

describe VersionObserver do

  before(:each) do
    Version.observers.disable VersionObserver
    @obs = VersionObserver.instance
  end

  after(:all) do
    # Add the observer again
    Version.observers.enable VersionObserver
  end

  it "should create new timeline events" do
    pkg = create(:version).package
    v = create :version, :package => pkg, :version => "2.0"
    TimelineEvent.should_receive(:create!)
    @obs.after_create(v)
  end

  it "should not create timeline events when there already is an event for the package release" do
    v = create :version
    TimelineEvent.should_not_receive(:create!)
    @obs.after_create(v)
  end

end
