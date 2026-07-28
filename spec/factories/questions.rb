FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "質問#{n}" }
    theme { :common }
    answer_type { :selection }
    sequence(:position) { |n| n }
  end
end
