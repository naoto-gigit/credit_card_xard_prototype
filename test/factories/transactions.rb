FactoryBot.define do
  factory :transaction do
    association :card
    sequence(:merchant_name) { |n| [ "コンビニ", "スーパー", "レストラン", "ガソリンスタンド", "デパート" ][n % 5] }
    amount { rand(1000..50000) }
    transacted_at { rand(30.days).seconds.ago }

    # 高額取引
    trait :large_amount do
      amount { rand(100000..500000) }
      merchant_name { "高級レストラン" }
    end

    # 少額取引
    trait :small_amount do
      amount { rand(100..1000) }
      merchant_name { "コンビニ" }
    end

    # 今月の取引
    trait :this_month do
      transacted_at { rand(Date.current.beginning_of_month..Date.current) }
    end

    # 先月の取引
    trait :last_month do
      transacted_at { rand(1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
    end
  end
end
