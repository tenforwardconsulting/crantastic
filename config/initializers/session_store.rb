# Be sure to restart your server when you modify this file.

Crantastic::Application.config.session_store :cookie_store, key: '_crantastic_session'

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :key         => '_crantastic_session',
    :secret      => 'c4ac317cbe898d0d3f36b98a7817b1139897b106be50e928e96fe26b7b5699cf52cc9cc242ddbd888792c07d61c386b10653804e44e0d64e1cf99f5d9611cccb'
  }
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Crantastic::Application.config.session_store :active_record_store
