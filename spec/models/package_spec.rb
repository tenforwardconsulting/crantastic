require 'rails_helper'

RSpec.describe Package do

  before(:each) do
    FactoryGirl.create_list :user, 2

    bio_infer_package = FactoryGirl.create :package, name: 'bio.infer', updated_at: 1.day.ago
    ggplot_package = FactoryGirl.create :package, name: 'ggplot2', updated_at: 2.days.ago
    FactoryGirl.create :version, package: bio_infer_package, maintainer: FactoryGirl.create(:author)
    FactoryGirl.create :version, package: ggplot_package, maintainer: FactoryGirl.create(:author)
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
    expect(Package.new(:name => "Bio.infeR")).not_to be_valid
    expect(Package.new(:name => "GGPLOT2")).not_to be_valid
    expect(Package.new(:name => "foobar_package")).to be_valid
  end

  it "should be considered equal if they have the same name" do
    expect(Package.find_by_name("bio.infer")).to eq(Package.find_by_name("bio.infer"))
    expect(Package.find_by_name("bio.infer")).not_to eq(Package.find_by_name("ggplot2"))
  end

  it "should use dashes instead of dots for params" do
    p = Package.new(:name => "bio.infer")
    expect(p.to_param).to eq("bio-infer")
  end

  it "should have name as to_s representation" do
    expect(Package.new(:name => "bio.infer").to_s).to eq("bio.infer")
  end

  it "should be case insensitive when finding by param" do
    expect(Package.find_by_param("bio.infer")).to eq(Package.find_by_param("BIO.Infer"))
  end

  it "should be marked as updated after it receives a new version" do
    pkg = Package.find_by_param("bio.infer")
    prev_time = pkg.updated_at
    FactoryGirl.create :version, :package => pkg, :maintainer => Author.first, :version => "5.3"
    expect(pkg.updated_at > prev_time).to eq true
  end

  it "should be marked as updated after it receives a new tagging" do
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    FactoryGirl.create :tagging, :package => pkg, :user => User.first
    expect(pkg.updated_at > prev_time).to eq true
  end

  it "should be marked as updated after it receives a new rating" do
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    FactoryGirl.create :package_rating, :package => pkg, :user => User.first
    expect(pkg.updated_at > prev_time).to eq true
  end

  it "should be marked as updated after it receives a new review" do
    pkg = Package.find_by_param("ggplot2")
    prev_time = pkg.updated_at
    FactoryGirl.create :review, :package => pkg, :version => pkg.latest, :user => User.last
    expect(pkg.updated_at > prev_time).to eq true
  end

  it "should return the created_at timestamp if updated_at is nil" do
    pkg = FactoryGirl.create :package
    expect(pkg.updated_at).to eq(pkg.created_at)
    sql = "UPDATE package SET updated_at = NULL where id = #{pkg.id}"
    ActiveRecord::Base.connection.execute(sql)
    pkg.reload
    expect(pkg.attributes["updated_at"]).to eq(nil)
    expect(pkg.updated_at).to eq(pkg.created_at)
  end

  describe "Delegation" do

    it "should delegate authors to latest version" do
      expect(@pkg.authors).to eq(@pkg.latest_version.authors)
    end

    it "should delegate license to latest version" do
      expect(@pkg.license).to eq(@pkg.latest_version.license)
    end

    it "should delegate maintainer to latest version" do
      expect(@pkg.maintainer).to eq(@pkg.latest_version.maintainer)
    end

  end

  describe "Package ratings" do

    it "should calculate its average rating" do
      u1 = User.first
      u2 = User.last
      p = Package.create!(:name => "aaMI")
      expect(p.average_rating).to eq(0)
      u1.rate!(p, 1)
      expect(p.average_rating).to eq(1)
      u2.rate!(p, 5)
      expect(p.average_rating).to eq(3)
      # also check relation counts
      expect(p.package_ratings.count).to eq(2)
      expect(p.overall_package_ratings.count).to eq(2)
      expect(p.documentation_package_ratings.count).to eq(0)
    end

    it "discards old ratings" do
      u = User.first
      p = FactoryGirl.create :package

      u.rate!(p, 1)
      r1 = u.rating_for(p)
      expect(r1.rating).to eq(1)

      u.rate!(p.id, 2) # supports numerical ids as well
      r2 = u.rating_for(p)
      expect(r2.rating).to eq(2)

      # Should be same PackageRating row
      expect(r1.id).to eq(r2.id)
    end

  end

end
