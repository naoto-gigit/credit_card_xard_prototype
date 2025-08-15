FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    name { "テストユーザー" }
    address { "東京都千代田区1-1-1" }
    phone_number { "090-1234-5678" }

    # 法人所属ユーザー
    trait :corporate do
      association :corporation
    end

    # 管理者ユーザー（将来的に管理者機能を追加する場合）
    trait :admin do
      sequence(:email) { |n| "admin#{n}@example.com" }
      name { "管理者" }
    end
  end
end
