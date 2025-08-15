FactoryBot.define do
  factory :card_application do
    association :applicant, factory: :user
    association :user
    annual_income { 5000000 }
    employment_status { "正社員" }
    employment_years { 5 }

    # 法人カード申請
    trait :corporate do
      association :applicant, factory: :corporation
    end

    # 承認済み申請
    trait :approved do
      credit_decision { "approved" }
      credit_score { 750 }
      credit_limit { 100 }
    end

    # 否決申請
    trait :rejected do
      credit_decision { "rejected" }
      credit_score { 400 }
      credit_limit { 0 }
    end

    # 審査中申請
    trait :pending do
      credit_decision { nil }
      credit_score { nil }
      credit_limit { nil }
    end

    # 高年収申請者
    trait :high_income do
      annual_income { 10000000 }
      employment_years { 10 }
    end

    # 低年収申請者
    trait :low_income do
      annual_income { 2000000 }
      employment_years { 1 }
    end
  end
end
