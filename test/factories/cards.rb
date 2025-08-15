FactoryBot.define do
  factory :card do
    association :owner, factory: :user
    sequence(:xard_card_id) { |n| "XARD#{n.to_s.rjust(10, '0')}" }
    sequence(:last_4_digits) { |n| (1000 + n % 9000).to_s }
    credit_limit { 50 }
    status { "active" }

    # 法人カード
    trait :corporate do
      association :owner, factory: :corporation
    end

    # 一時増額中のカード
    trait :with_temporary_limit do
      temporary_limit { 100 }
      temporary_limit_expires_at { 1.month.from_now }
    end

    # 停止中のカード
    trait :suspended do
      status { "suspended" }
    end

    # 解約済みカード
    trait :terminated do
      status { "terminated" }
    end

    # 高限度額カード
    trait :high_limit do
      credit_limit { 200 }
    end
  end
end
