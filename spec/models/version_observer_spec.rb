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
    expect(TimelineEvent).to receive(:create!)
    @obs.after_create(v)
  end

  it "should not create timeline events when there already is an event for the package release" do
    v = create :version
    expect(TimelineEvent).not_to receive(:create!)
    @obs.after_create(v)
  end

end
