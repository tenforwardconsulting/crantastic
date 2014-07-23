require 'spec_helper'

describe Review do

  #should_validate_length_of :review, :minimum => 3
  #should_validate_length_of :title, :minimum => 3

  before(:each) do
    create :version
    create :user
  end

  it "should strip title and review before validation" do
    r = Review.new(:title => " title \r\n")
    r.valid?
    r.title.should == "title"
  end

  it "should store package version" do
    pkg = Package.first
    review = Review.create!(:package => pkg, :user => User.first,
                            :title => "Title", :review => "Lorem")
    review.reload
    review.version.should == pkg.latest
  end

end
