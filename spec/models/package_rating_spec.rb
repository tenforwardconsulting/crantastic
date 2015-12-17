require 'rails_helper'

RSpec.describe PackageRating do
  before(:each) do
    @valid_attributes = {
      :user => FactoryGirl.create(:user),
      :package => FactoryGirl.create(:package),
      :rating => 2
    }
  end

  #should_allow_values_for :rating, "1", "2", "3", "4", "5"
  #should_not_allow_values_for :rating, "0", "6", "-1", "10"

  it "should create a new instance given valid attributes" do
    PackageRating.create!(@valid_attributes)
  end

  it "shouldn't be possible for a user to have two active votes for one package" do
    expect(PackageRating.create(@valid_attributes)).to be_valid
    expect(PackageRating.create(@valid_attributes)).not_to be_valid
  end

  it "should be possible for a user to have two active votes for one package with different aspects" do
    expect(PackageRating.create(@valid_attributes)).to be_valid
    expect(PackageRating.create(@valid_attributes.merge(:aspect => "documentation"))).to be_valid
  end

  it "should have a default rating aspect" do
    expect(PackageRating.create!(@valid_attributes).aspect).to eq("overall")
  end
end
