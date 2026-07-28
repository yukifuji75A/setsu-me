FactoryBot.define do
  factory :answer do
    association :user
    association :question

    trait :selection do
      association :question_option
      body { nil }
    end

    trait :text do
      question { association :question, answer_type: :text }
      body { "テスト回答" }
      question_option { nil }
    end
  end
end
