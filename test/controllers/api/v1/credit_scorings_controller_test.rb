require "test_helper"

class Api::V1::CreditScoringsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card_application = card_applications(:one)
  end

  test "should respond successfully" do
    # APIエンドポイントにPOSTリクエストを送信します。
    post api_v1_credit_scorings_url, params: { card_application_id: @card_application.id }

    # レスポンスが成功したことを確認します。
    assert_response :success
  end
end
