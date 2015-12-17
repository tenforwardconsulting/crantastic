FactoryGirl.define do
  factory :review do
    user
    package
    version
    title { Faker::Commerce.product_name }
    review { Faker::Lorem.paragraph }
  end
end
