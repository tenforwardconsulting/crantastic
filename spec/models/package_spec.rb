require 'spec_helper'

describe Package do

  before(:each) do
    create_list :user, 2

    bio_infer_package = create :package, name: 'bio.infer', updated_at: 1.day.ago
    ggplot_package = create :package, name: 'ggplot2', updated_at: 2.days.ago
    create :version, package: bio_infer_package, maintainer: create(:author)
    create :version, package: ggplot_package, maintainer: create(:author)
    @pkg = Package.first
  end

  #should_have_scope :recent

  #should_validate_presence_of :name
  #should_validate_uniqueness_of :name
  #should_validate_length_of :name, :minimum => 2, :maximum => 255

  #should_have_many :versions
  #should_have_many :package_ratings
  #should_have_many :overall_package_ratings
  #should_have_many :documentation_package_ratings
  #should_have_many :reviews
  #should_have_many :taggings

  it "should be case insensitive on package name" do
    Package.new(:name => "Bio.infeR").should_not be_valid
    Package.new(:name => "GGPLOT2").should_not be_valid
    Package.new(:name => "foobar_package").should be_valid
  end

  it "should be considered equal if they have the same name" do
    Package.find_by_name("bio.infer").should == Package.find_by_name("bio.infer")
    Package.find_by_name("bio.infer").should_not == Package.find_by_name("ggplot2")
  end

  it "should use dashes instead of dots for params" do
    p = Package.new(:name => "bio.infer")
    p.to_param.should == "bio-infer"
  end

  it "should have name as to_s representation" do
    Package.new(:name => "bio.infer").to_s.should == "bio.infer"
  end

  it "should be case insensitive when finding by param" do
    Package.find_by_param("bio.infer").should == Package.find_by_param("BIO.Infer")
  end

  it "should be marked as updated after it receives a new version" do
    pkg = Package.find_by_param("bio.infer")
    prev_time = pkg.updated_at
    create :version, :package => pkg, :maintainer => Author.first, :version => "5.3"
    (pkg.updated_at > prev_time).should be_truthy
  end

  it "should be marked as updated after it receives a new tagging" do
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    create :tagging, :package => pkg, :user => User.first
    (pkg.updated_at > prev_time).should be_truthy
  end

  it "should be marked as updated after it receives a new rating" do
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    create :package_rating, :package => pkg, :user => User.first
    (pkg.updated_at > prev_time).should be_truthy
  end

  it "should be marked as updated after it receives a new review" do
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    create :review, :package => pkg, :version => pkg.latest, :user => User.last
    (pkg.updated_at > prev_time).should be_truthy
  end

  it "should return the created_at timestamp if updated_at is nil" do
    pkg = create :package
    pkg.updated_at.should == pkg.created_at
    sql = "UPDATE package SET updated_at = NULL where id = #{pkg.id}"
    ActiveRecord::Base.connection.execute(sql)
    pkg.reload
    pkg.attributes["updated_at"].should == nil
    pkg.updated_at.should == pkg.created_at
  end

  describe "Delegation" do

    it "should delegate authors to latest version" do
      @pkg.authors.should == @pkg.latest_version.authors
    end

    it "should delegate license to latest version" do
      @pkg.license.should == @pkg.latest_version.license
    end

    it "should delegate maintainer to latest version" do
      @pkg.maintainer.should == @pkg.latest_version.maintainer
    end

  end

  describe "Package ratings" do

    it "should calculate its average rating" do
      u1 = User.first
      u2 = User.last
      p = Package.create!(:name => "aaMI")
      p.average_rating.should == 0
      u1.rate!(p, 1)
      p.average_rating.should == 1
      u2.rate!(p, 5)
      p.average_rating.should == 3
      # also check relation counts
      p.package_ratings.count.should == 2
      p.overall_package_ratings.count.should == 2
      p.documentation_package_ratings.count.should == 0
    end

    it "should discard old ratings" do
      u = User.first
      p = create :package

      u.rate!(p, 1)
      r1 = u.rating_for(p)
      r1.rating.should == 1

      u.rate!(p.id, 2) # supports numerical ids as well
      r2 = u.rating_for(p)
      r2.rating.should == 2

      # Should be same PackageRating row
      r1.id.should == r2.id
    end

  end

end
