# == Schema Information
#
# Table name: author
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Author do

  #should_allow_values_for :name, "John Doe", :allow_nil => false
  #should_validate_length_of :name, :minimum => 2, :maximum => 255
  #should_allow_values_for :email, "john@doe.co.uk", "", "X", :allow_nil => true
  #should_validate_length_of :email, :minimum => 0, :maximum => 255
  #should_have_many :versions

  it "should have unique values for email scoped on name" do
    Author.new_from_string("John Doe <john.doe@acme.co.uk>")
    validate_uniqueness_of :email, :scope => :name, :case_sensitive => false
  end

  it "should create new from string" do
    Author.should_receive(:find_or_create_by_name).with("Unknown")
    Author.new_from_string("")

    Author.should_receive(:find_or_create).with("John Doe", nil)
    Author.new_from_string("John Doe")

    Author.should_receive(:find_or_create_by_name).with("Unknown")
    Author.new_from_string("john@doe.com")

    Author.should_receive(:find_or_create).with("John Doe", "john@doe.com")
    Author.new_from_string("John Doe <john@doe.com>")
  end

  it "should have a string representation" do
    Author.new(:name => "John").to_s.should == "John"
  end

  it "should find or create" do
    j = Author.make(:name => "John", :email => nil)
    h = Author.make(:name => "Harry")

    Author.find_or_create("Harry", nil).should == h
    Author.find_or_create(nil, h.email).should == h
  end

  it "should be connected with versions and packages" do
    v = Version.make
    a = v.maintainer
    a.versions.should == [v]
    a.packages.should == [v.package]
  end

end
