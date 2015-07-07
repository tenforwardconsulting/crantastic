require 'rails_helper'

RSpec.describe TimelineEvent do
  let(:timeline_event) { FactoryGirl.build(:timeline_event) }

  #should_validate_presence_of :event_type

  before(:each) do
    FactoryGirl.create :package_rating
  end

  it 'has a valid factory' do
    expect(timeline_event).to be_valid
  end

  describe 'validations' do
    it 'requires an event_type' do
      timeline_event.event_type = nil
      expect(timeline_event).to_not be_valid
    end

    it 'allows actor to be blank' do
      timeline_event.actor = nil
      expect(timeline_event).to be_valid
    end

    it 'allows secondary_subject to be blank' do
      timeline_event.secondary_subject = nil
      expect(timeline_event).to be_valid
    end

  end

  it "should cache package ratings" do
    event = FactoryGirl.create(:package_rating_event)
    expect(event.cached_value.to_i).to eq(event.subject.rating.to_i)
  end

  it "should cache task view versions" do
    event = FactoryGirl.create(:task_view).update_version("2009-09-09")
    expect(event.cached_value).to eq(TaskView.first.version)
  end

  {
    "new_package" => true,
    "new_version" => true,
    "new_review" => false,
  }.each do |event_type, is_package_event|
    it "knows if #{event_type} is #{is_package_event ? "a" : "not a" } package event" do
      timeline_event.event_type = event_type
      expect(timeline_event.package_event?).to eq(is_package_event)
    end
  end

end
