FactoryGirl.define do
  factory :timeline_event do
    event_type "new_package_rating"

    trait :with_subject do
      association :subject, factory: :package_rating

      trait :with_secondary_subject do
        association :secondary_subject, factory: :package
      end
    end

    trait :with_actor do
      association :actor, factory: :user
    end

    factory :user_timeline_event, traits: [:with_actor]

    factory :package_rating_event, traits: [:with_subject]

    factory :timeline_event_for_version do
      event_type "new_version"

      association :subject, factory: :version

      after(:build) do |timeline_event, evaluator|
        timeline_event.secondary_subject = timeline_event.subject.package
      end
    end
  end

end
