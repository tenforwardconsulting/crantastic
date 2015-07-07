require 'spec_helper'

describe Tag do

  before(:each) do
    create :tagging
    create :package, :name => 'ggplot2'
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
    new_tag.should == @tag
  end

  it "should return its name when to_s is called" do
    @tag.name = "cool"
    @tag.to_s.should == "cool"
  end

  it "should find or create with LIKE by name" do
    Tag.find_or_create_with_like_by_name("tag123").should ==
      Tag.find_or_create_with_like_by_name("TAG123")
  end

  it "should parse tag list" do
    Tag.should_receive(:find_or_create_with_like_by_name).with("tag1").at_most(3).times
    Tag.should_receive(:find_or_create_with_like_by_name).twice.with("tag2")
    Tag.should_receive(:find_or_create_with_like_by_name).once.with("graphics-device")
    Tag.parse_and_find_or_create("tag1 , tag2").size.should == 2
    Tag.parse_and_find_or_create("tag1 tag2").size.should == 2
    Tag.parse_and_find_or_create("\"graphics device\"").size.should == 1
    Tag.parse_and_find_or_create("tag1, ").size.should == 1
  end

  it "should be marked as updated after it receives a new tagging" do
    tag = create :tag
    prev_time = tag.updated_at
    create :tagging, :package => Package.find_by_param("ggplot2"),
                    :user => User.first,
                    :tag => tag
    (tag.updated_at > prev_time).should be_truthy
  end

  describe TaskView do

    it "should update its version and fire a timeline event" do
      t = create :task_view, :version => "2009-06-06"
      TimelineEvent.should_receive(:create!)
      t.update_version("2009-07-07")
      t.version.should == "2009-07-07"
    end

  end

end
