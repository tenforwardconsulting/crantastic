FactoryGirl.define do
  factory :version do
    version { Faker::Lorem.word }
    name { Faker::Lorem.word }
    package
    maintainer { FactoryGirl.create :author }
  end
end
