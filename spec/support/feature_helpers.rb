module FeatureHelpers
  def login_with_valid_credentials(login = "john", password = "test")
    visit login_url
    fill_in "login", with: login
    fill_in "password", with: password
    click_button "login"
  end
end
