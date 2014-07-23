FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    login { Faker::Name.first_name }
    password { Faker::Internet.password }
    password_confirmation { password }
    tos { true }
  end
end
