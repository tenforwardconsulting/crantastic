require 'spec_helper'

describe Review do

  let(:review) { FactoryGirl.build :review }
  #should_validate_length_of :review, :minimum => 3
  #should_validate_length_of :title, :minimum => 3

  before(:each) do
    create :version
    create :user
  end
  it 'has a valid factory' do
    expect(review).to be_valid
  end

  it "should strip title and review before validation" do
    r = Review.new(:title => " title \r\n")
    r.valid?
    expect(r.title).to eq("title")
  end

  it "should store package version" do
    pkg = Package.first
    review = Review.create!(:package => pkg, :user => User.first,
                            :title => "Title", :review => "Lorem")
    review.reload
    expect(review.version).to eq(pkg.latest)
  end

end
