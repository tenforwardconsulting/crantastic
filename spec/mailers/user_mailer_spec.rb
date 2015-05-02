require 'spec_helper'

describe UserMailer do

  before(:each) do
    @user = User.create(:login => "Helene", :email => "helene@helene.no",
                        :password => "1234", :password_confirmation => "1234",
                        :tos => true)
  end

  describe "when sending an e-mail" do
    before(:each) do
      @email = UserMailer.create_activation_instructions(@user)
    end

    it "should be sent to the user's email address" do
      @email.to.should == [@user.email]
    end

    it "should include an activation link" do
      # localhost for test environment, crantastic.org for production
      @email.body.match(" http://localhost:3000/activate/#{@user.perishable_token} ").should_not be_nil
    end
  end

end
