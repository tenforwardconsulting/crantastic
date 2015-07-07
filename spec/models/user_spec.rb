require 'rails_helper'

RSpec.describe User do

  before(:each) do
    FactoryGirl.create :user
    FactoryGirl.create :version
  end

  it "accounts created with rpx should be valid even if they have blank password" do
    u = User.new(:login => "puppet", :email => "puppet@acme.com")
    expect(u).not_to be_valid
    u.from_rpx = true
    expect(u).to be_valid
  end

  it "accounts created with rpx should be valid even if they have blank emails" do
    u = User.new(:login => "puppet", :email => nil)
    expect(u).not_to be_valid
    u.from_rpx = true
    expect(u).to be_valid
  end

  it "accounts created with rpx should be valid even if they have weird usernames" do
    u = User.new(:login => "foo~|baz|")
    expect(u).not_to be_valid
    u.from_rpx = true
    expect(u).to be_valid
  end

  it "should not allow mismatched passwords" do
    u = User.new(:login => "puppet", :email => "puppet@acme.com",
                 :password => "foobar", :password_confirmation => "bazbar")
    expect(u).not_to be_valid
    expect(u.errors[:password].first).to eq("doesn't match confirmation")
  end

  it "should store activation time when activated" do
    u = User.new
    expect(u).to receive(:save!)
    expect(u).not_to be_active
    u.activate
    expect(u).to be_active
    expect(u.activated_at).to be_kind_of(Time)
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
    expect(u.author_of?(pkg)).to eq false
    u.author_identities << AuthorIdentity.new(:author => a)
    u.reload
    expect(u.author_of?(pkg)).to eq true
  end

  describe "Package voting" do

    it "should know if the user uses a package" do
      u = User.first
      pkg = Package.first

      expect(u.uses?(pkg)).to eq false
      PackageUser.create!(:package => pkg, :user => u)
      expect(u.uses?(pkg)).to eq true
    end

    it "should toggle votes for a package" do
      u = User.first
      pkg = Package.first

      expect(u.toggle_usage(pkg)).to eq true
      expect(u.uses?(pkg)).to eq true
      expect(u.toggle_usage(pkg)).to eq false
      expect(u.uses?(pkg)).to eq false
      expect(u.toggle_usage(pkg)).to eq true
      expect(u.uses?(pkg)).to eq true
    end

  end

end
