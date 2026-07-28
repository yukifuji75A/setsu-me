FactoryBot.define do
  factory :question_option do
    association :question
    sequence(:label) { |n| "選択肢#{n}" }
    sequence(:position) { |n| n }
  end
end
