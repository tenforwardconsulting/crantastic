FactoryGirl.define do
  sequence :name do |n|
    "some_name#{n}"
  end
  factory :version do
    version {generate(:name) }
    name { generate(:name) }
    package
    maintainer { FactoryGirl.create :author }
  end
end
