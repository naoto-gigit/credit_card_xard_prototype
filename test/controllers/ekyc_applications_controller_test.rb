require "test_helper"

class EkycApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # テストユーザーをセットアップ
    sign_in @user # ログインさせる
  end

  test "should get new" do
    get new_ekyc_application_url
    assert_response :success
  end

  test "should create ekyc_application" do
    assert_difference("EkycApplication.count") do
      post ekyc_applications_url, params: { ekyc_application: {
        document_type: "運転免許証",
        document_number: "1234567890",
        full_name: "テスト太郎",
        date_of_birth: "2000-01-01",
        address: "東京都",
        company_name: "テスト株式会社",
        employment_type: "正社員",
        years_of_service: 3,
        annual_income: 400,
        other_debt: 50
      } }
    end
    assert_redirected_to profile_url # 成功したらprofile_urlにリダイレクトされることを確認
  end
end
