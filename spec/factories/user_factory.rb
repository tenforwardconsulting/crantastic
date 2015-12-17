FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    sequence(:login) { |n| "username_#{n}" }
    password { Faker::Internet.password }
    password_confirmation { password }
    tos { true }
  end
end
