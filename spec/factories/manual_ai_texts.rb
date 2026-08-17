FactoryBot.define do
  factory :manual_ai_text do
    association :manual
    section_type { :basic_spec }
    ai_text { "AIが生成したテスト文章です。" }
  end
end
