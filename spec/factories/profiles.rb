FactoryBot.define do
  factory :profile do
    association :user
    name { "テストユーザー" }
    birthday { Date.new(2000, 1, 1) }
    hometown { :tokyo }
    education { :university }
    blood_type { :type_a }
  end
end
