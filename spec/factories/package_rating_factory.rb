FactoryGirl.define do
  factory :package_rating do
    user
    package
    rating { rand 1..5 }
    aspect { ['overall', 'documentation'].sample }
  end
end
