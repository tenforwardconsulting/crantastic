require 'spec_helper'

describe Version do

  let(:version) { FactoryGirl.build_stubbed :version }
  let(:author) { FactoryGirl.build_stubbed :author }
  let(:package) { version.package }

  it 'has a valid factory' do
    expect(version).to be_valid
  end

  describe "validations" do
    it 'does not require a title' do
      version.title = nil
      expect(version).to be_valid
    end
    it 'does not require a url' do
      version.url = nil
      expect(version).to be_valid
    end
    it 'requires a version' do
      version.version = nil
      expect(version).to_not be_valid
    end

    it 'requires names to be >1 character' do
      version.name = "a"
      expect(version).to_not be_valid
    end

    it 'requires names to be <256 characters' do
      version.name = "a"*256
      expect(version).to_not be_valid
    end
    it 'requires version to be >0 character' do
      version.version = ""
      expect(version).to_not be_valid
    end

    it 'requires version to be <26 characters' do
      version.version = "a"*26
      expect(version).to_not be_valid
    end
    it 'requires title to be <256 characters' do
      version.title = "a"*256
      expect(version).to_not be_valid
    end

  end

  it "should set itself as the package's latest version when created'" do
    version_1 = FactoryGirl.create(:version)
    package = version_1.package
    package.latest_version.should == version_1

    ver2 = Version.new do |v|
      v.package = package
      v.name = package.name
      v.version = "2.0"
      v.maintainer = author
    end
    ver2.save!
    package.latest_version.should == ver2
  end

  it "should know its previous version" do
    ver1 = package.versions.first
    ver2 = Version.new do |v|
      v.package = package
      v.name = package.name
      v.version = "3.0"
      v.maintainer = author
    end
    ver2.save!

    ver2.previous.should == ver1
  end

  it "should use its version as a string representation" do
    expect(version.to_s).to eq(version.version)
  end

  it "should know its cran url" do
    expect(version.cran_url).to eq("http://cran.r-project.org/web/packages/#{version.name}")
  end

  it "should produce a list of urls" do
    version.url = "http://foo, http://bar"

    version.urls.should == ["http://foo", "http://bar",
                        "http://cran.r-project.org/web/packages/#{version.name}"]
  end

  it "should handle priority taggings" do
    package = FactoryGirl.create(:version).package
    package.tags.type("Priority").size.should == 0

    FactoryGirl.create(:version, :package => package,
                 :priority => "",
                 :maintainer => Author.first)
    package.tags.type("Priority").size.should == 0

    FactoryGirl.create(:version, :package => package,
                 :version => "2.5",
                 :priority => "recommended",
                 :maintainer => Author.first)

    package.tags.type("Priority").size.should == 1
    package.tags.type("Priority").first.name.should == "Recommended"

    FactoryGirl.create(:version, :package => package,
                 :version => "3.0",
                 :priority => "base, recommended",
                 :maintainer => Author.first)
    package.tags.type("Priority").size.should == 2

    FactoryGirl.create(:version, :package => package,
                 :version => "3.5",
                 :priority => "recommended",
                 :maintainer => Author.first)

    package.tags.type("Priority").size.should == 1
    package.tags.type("Priority").first.name.should == "Recommended"

    # New version w/o priority, old priority tagging should be removed
    FactoryGirl.create(:version, :package => package,
                 :version => "4.0",
                 :priority => "",
                 :maintainer => Author.first)
    package.tags.type("Priority").size.should == 0
  end

  it "should prefer publication/package date over the regular date field" do
    version.date = "2008-05-05"
    version.date.to_s.should == "2008-05-05"
    version.publicized_or_packaged = "2009-12-12"
    version.date.to_date.to_s.should == "2009-12-12"
  end

  it "should parse the author list" do
    a1 = FactoryGirl.create(:author, :name => "Ian Rush")
    a2 = FactoryGirl.create(:author, :name => "Rob Fowler")
    v = FactoryGirl.build(:version, :author => "Ian Rush, Rob Fowler")
    v.parse_authors.should == [a1, a2]

    v.author = nil
    v.parse_authors.should == []
  end

end
