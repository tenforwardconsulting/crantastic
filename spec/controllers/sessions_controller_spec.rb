require 'spec_helper'

describe SessionsController do

  describe "RPX Now integration" do

    it "should return status forbidden if accessing rpx_token without a token" do
      get "rpx_token"
      expect(response.status).to eq(403)
    end

    it "should create a user from RPXNow user data" do
      create(:user, email: 'john@domain.com').activate
      user = User.find_by_email("john@domain.com")
      token = "asdfasdf1231231ij"
      data = {
        :name => "John Doe", :username => "john",
        :email => "john@domain.com", :identifier => "abc123"
      }
      expect(RPXNow).to receive(:user_data).with(token).and_return(data)

      rpx_proxy = RPXNow::UserProxy.new(user.id)
      expect(rpx_proxy).to receive(:map).with(data[:identifier])
      expect(user).to receive(:rpx).and_return(rpx_proxy)

      expect(User).to receive(:find_by_email).with("john@domain.com").and_return(user)

      get :rpx_token, :token => token

      expect(flash[:notice]).to eq("Logged in successfully!")
      expect(response).to be_redirect
      expect(response).to redirect_to("http://test.host/users/#{user.id}")
    end

  end

end
