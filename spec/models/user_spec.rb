require 'spec_helper'

describe User do

  before(:each) do
    create :user
    create :version
  end

  it "accounts created with rpx should be valid even if they have blank password" do
    u = User.new(:login => "puppet", :email => "puppet@acme.com")
    u.should_not be_valid
    u.from_rpx = true
    u.should be_valid
  end

  it "accounts created with rpx should be valid even if they have blank emails" do
    u = User.new(:login => "puppet", :email => nil)
    u.should_not be_valid
    u.from_rpx = true
    u.should be_valid
  end

  it "accounts created with rpx should be valid even if they have weird usernames" do
    u = User.new(:login => "foo~|baz|")
    u.should_not be_valid
    u.from_rpx = true
    u.should be_valid
  end

  it "should not allow mismatched passwords" do
    u = User.new(:login => "puppet", :email => "puppet@acme.com",
                 :password => "foobar", :password_confirmation => "bazbar")
    u.should_not be_valid
    u.errors[:password].first.should == "doesn't match confirmation"
  end

  it "should store activation time when activated" do
    u = User.new
    u.should_receive(:save!)
    u.should_not be_active
    u.activate
    u.should be_active
    u.activated_at.should be_kind_of(Time)
  end

  it "should cache the compiled profile markdown" do
    u = User.first
    markdown = "**Hello** _world_"
    u.profile = markdown
    u.save(validate: false)
    u.reload
    expect(u.profile_html).to have_tag("p") do
      with_tag("strong") do
        with_text(/Hello/)
      end
      with_tag("em") do
        with_text(/world/)
      end
    end
  end

  it "should be identified as the author of a package" do
    u = User.first
    pkg = Package.first
    a = Author.first
    u.author_of?(pkg).should be_falsey
    u.author_identities << AuthorIdentity.new(:author => a)
    u.reload
    u.author_of?(pkg).should be_truthy
  end

  describe "Package voting" do

    it "should know if the user uses a package" do
      u = User.first
      pkg = Package.first

      u.uses?(pkg).should be_falsey
      PackageUser.create!(:package => pkg, :user => u)
      u.uses?(pkg).should be_truthy
    end

    it "should toggle votes for a package" do
      u = User.first
      pkg = Package.first

      u.toggle_usage(pkg).should be_truthy
      u.uses?(pkg).should be_truthy
      u.toggle_usage(pkg).should be_falsey
      u.uses?(pkg).should be_falsey
      u.toggle_usage(pkg).should be_truthy
      u.uses?(pkg).should be_truthy
    end

  end

end
