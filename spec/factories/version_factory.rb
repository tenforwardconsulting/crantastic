FactoryGirl.define do
  factory :version do
    version { Faker::Lorem.word }
    name { Faker::Lorem.word }
    package

    trait :with_maintainer do
      maintainer { FactoryGirl.create :author }
    end
  end
end
