FactoryGirl.define do
  sequence :package_name do |n|
    "package_name#{n}"
  end
  factory :package do
    name { generate(:package_name) }
  end
end
