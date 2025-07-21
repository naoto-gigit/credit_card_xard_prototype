require "test_helper"
require "webmock/minitest"

class Api::V1::EkycVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card_application = card_applications(:one)
  end

  test "should respond successfully" do
    stub_request(:post, "http://localhost:3000/webhooks/ekyc_statuses")
      .to_return(status: 200, body: "", headers: {})

    # APIエンドポイントにPOSTリクエストを送信します。
    # この中で、sleepやwebhook送信が実際に実行されます。
    post api_v1_ekyc_verifications_url, params: { card_application_id: @card_application.id }

    # レスポンスが成功したことを確認します。
    assert_response :success
  end
end
