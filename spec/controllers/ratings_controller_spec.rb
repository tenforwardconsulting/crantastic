require 'rails_helper'

include AuthHelper

RSpec.describe RatingsController do

  it "should require login" do
    post :create, :package_id => "aaMI"
    expect(response).to be_redirect
  end

  it "should create new ratings" do
    login_as_user(:id => 1, :login => "test")
    package = mock_model(Package, :id => 1)
    expect(Package).to receive(:first).and_return(package)
    expect(@current_user).to receive(:rate!).with(package, 5, "overall")
    post :create, :package_id => "aaMI", :rating => 5, :aspect => "overall"
  end

end
