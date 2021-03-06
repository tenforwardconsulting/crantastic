require 'rails_helper'

RSpec.describe TaggingsController do

  include AuthHelper

  let(:tagging) { FactoryGirl.create :tagging, :with_package }
  let(:user) { FactoryGirl.create :user, login: 'malicious' }

  it "should redirect to login when attempting to tag without logging in first" do
    get :new, :package_id => "aaMI"
    expect(response).to be_redirect
    expect(flash[:notice]).to match(/You need to log in to access this page/)
  end

  it "should allow users to delete their own taggings" do
    expect(tagging).to be_persisted
    login_as_user(id: tagging.user.id)
    expect do
      delete :destroy, :package_id => tagging.package.name, :id => tagging.id
    end.to change(Tagging, :count).by(-1)
  end

  it "should not allow users to delete others taggings" do
    expect(tagging).to be_persisted
    login_as_user(id: user.id)
    expect do
      delete :destroy, :package_id => tagging.package.name, :id => tagging.id
    end.to change(Tagging, :count).by(0)
    expect(response.status).to eq(403)
  end

end
