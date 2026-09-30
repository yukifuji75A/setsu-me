FactoryBot.define do
  factory :manual do
    association :user
    theme { :default }

    trait :published do
      published_at { Time.current }
    end
  end
end
