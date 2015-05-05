require 'spec_helper'

describe UserMailer do
  let(:user) { FactoryGirl.create(:user) }

  describe ".activation_instructions" do
    it "should be sent to the user's email address" do
      email = UserMailer.activation_instructions(user)
      email.to.should == [user.email]
    end

    it "includes an activation link" do
      # localhost for test environment, crantastic.org for production
      email = UserMailer.activation_instructions(user)
      expect(email.body).to match("/activate/#{user.perishable_token} ")
    end
  end

end
