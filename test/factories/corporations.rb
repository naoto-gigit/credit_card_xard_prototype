FactoryBot.define do
  factory :corporation do
    sequence(:name) { |n| "株式会社テスト#{n}" }
    sequence(:name_kana) { |n| "カブシキガイシャテスト#{n}" }
    sequence(:registration_number) { |n| "#{1234567890000 + n}" }
    corporate_type { "株式会社" }
    establishment_date { 5.years.ago }
    address { "東京都千代田区丸の内1-1-1" }
    phone_number { "03-1234-5678" }
    website { "https://example.com" }

    # 小規模法人
    trait :small do
      name { "合同会社スモール" }
      name_kana { "ゴウドウガイシャスモール" }
      corporate_type { "合同会社" }
      establishment_date { 2.years.ago }
    end

    # 大企業
    trait :large do
      name { "大手株式会社" }
      name_kana { "オオテカブシキガイシャ" }
      establishment_date { 20.years.ago }
    end
  end
end
