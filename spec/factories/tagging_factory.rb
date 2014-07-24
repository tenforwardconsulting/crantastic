FactoryGirl.define do
  factory :tagging do

    trait :with_package do
      package
    end
  end
end
