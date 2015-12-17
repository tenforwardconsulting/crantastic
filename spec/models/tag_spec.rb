require 'rails_helper'

RSpec.describe Tag do

  before(:each) do
    FactoryGirl.create :tagging
    FactoryGirl.create :package, :name => 'ggplot2'
    @tag = Tag.new
  end

  #should_allow_values_for :name, "MachineLearning", "Point-and-click",
                                 #"AI", "NLP", :allow_nil => false
  #should_not_allow_values_for :name, "", "Machine Learning", " AI",
                                     #"asdf ", "sdf<h1>f"
  #should_validate_length_of :name, :minimum => 2, :maximum => 100

  it "should equal a tag with the same name" do
    @tag.name = "awesome"
    new_tag = Tag.new(:name => "awesome")
    expect(new_tag).to eq(@tag)
  end

  it "should return its name when to_s is called" do
    @tag.name = "cool"
    expect(@tag.to_s).to eq("cool")
  end

  it "should find or create with LIKE by name" do
    expect(Tag.find_or_create_with_like_by_name("tag123")).to eq(
      Tag.find_or_create_with_like_by_name("TAG123")
    )
  end

  it "should parse tag list" do
    expect(Tag).to receive(:find_or_create_with_like_by_name).with("tag1").at_most(3).times
    expect(Tag).to receive(:find_or_create_with_like_by_name).twice.with("tag2")
    expect(Tag).to receive(:find_or_create_with_like_by_name).once.with("graphics-device")
    expect(Tag.parse_and_find_or_create("tag1 , tag2").size).to eq(2)
    expect(Tag.parse_and_find_or_create("tag1 tag2").size).to eq(2)
    expect(Tag.parse_and_find_or_create("\"graphics device\"").size).to eq(1)
    expect(Tag.parse_and_find_or_create("tag1, ").size).to eq(1)
  end

  it "should be marked as updated after it receives a new tagging" do
    tag = FactoryGirl.create :tag
    prev_time = tag.updated_at
    FactoryGirl.create :tagging, :package => Package.find_by_param("ggplot2"),
                    :user => User.first,
                    :tag => tag
    expect(tag.updated_at > prev_time).to eq true
  end

  describe TaskView do

    it "should update its version and fire a timeline event" do
      t = FactoryGirl.create :task_view, :version => "2009-06-06"
      expect(TimelineEvent).to receive(:create!)
      t.update_version("2009-07-07")
      expect(t.version).to eq("2009-07-07")
    end

  end

end
