FactoryGirl.define do
  factory :tagging do
    user

    trait :with_package do
      package
    end

    trait :with_tag do
      tag
    end

    factory :tagging_of_package, traits: [:with_tag, :with_package]
  end
end
