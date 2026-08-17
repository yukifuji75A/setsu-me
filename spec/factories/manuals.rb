FactoryBot.define do
  factory :manual do
    association :user
    theme { :default }
  end
end
