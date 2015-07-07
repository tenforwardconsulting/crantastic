require 'spec_helper'

describe Author do

  #should_allow_values_for :name, "John Doe", :allow_nil => false
  #should_validate_length_of :name, :minimum => 2, :maximum => 255
  #should_allow_values_for :email, "john@doe.co.uk", "", "X", :allow_nil => true
  #should_validate_length_of :email, :minimum => 0, :maximum => 255
  #should_have_many :versions

  it "has unique values for email scoped on name" do
    author = Author.new_from_string("John Doe <john.doe@acme.co.uk>")
    expect(author).to be_valid
  end

  it "creates new from string" do
    expect(Author).to receive(:find_or_create_by_name).with("Unknown")
    Author.new_from_string("")

    expect(Author).to receive(:find_or_create).with("John Doe", nil)
    Author.new_from_string("John Doe")

    expect(Author).to receive(:find_or_create_by_name).with("Unknown")
    Author.new_from_string("john@doe.com")

    expect(Author).to receive(:find_or_create).with("John Doe", "john@doe.com")
    Author.new_from_string("John Doe <john@doe.com>")
  end

  it "has a string representation" do
    expect(Author.new(:name => "John").to_s).to eq("John")
  end

  it "should find or create" do
    john = create :author, name: 'John', email: nil
    harry = create :author, name: 'Harry'

    expect(Author.find_or_create("Harry", nil)).to eq(harry)
    expect(Author.find_or_create(nil, harry.email)).to eq(harry)
  end

  it "should be connected with versions and packages" do
    version = create :version
    author = version.maintainer
    expect(author.versions).to eq([version])
    expect(author.packages).to eq([version.package])
  end

end
