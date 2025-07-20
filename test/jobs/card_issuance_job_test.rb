# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class CardIssuanceJobTest < ActiveJob::TestCase
  setup do
    @card_application = card_applications(:one)
  end

  test "should issue a card when API call is successful" do
    # 成功レスポンスのモックを作成
    mock_response = Net::HTTPSuccess.new(1.0, "201", "Created")
    def mock_response.body
      {
        xard_card_id: "crd_test12345",
        last_4_digits: "1234",
        card_type: "Visa",
        status: "active",
        issued_at: Time.current
      }.to_json
    end

    # Net::HTTP.new が、リクエストを送信するモックオブジェクトを返すように設定
    mock_http = Minitest::Mock.new
    mock_http.expect :request, mock_response, [ Object ] # requestメソッドが呼ばれることを期待

    Net::HTTP.stub :new, mock_http do
      # ジョブを実行
      assert_difference("Card.count", 1) do
        CardIssuanceJob.perform_now(@card_application)
      end
    end

    # 作成されたカードの情報を検証
    new_card = Card.last
    card = Card.last
    assert_equal @card_application.applicant, card.owner
    assert_equal "crd_test12345", new_card.xard_card_id
    mock_http.verify # 期待通りにメソッドが呼ばれたか検証
  end

  test "should not issue a card when API call fails" do
    # 失敗レスポンスのモックを作成
    mock_response = Net::HTTPBadRequest.new(1.0, "400", "Bad Request")
    def mock_response.body; { error: "Failed" }.to_json; end

    # Net::HTTP.new が、リクエストを送信するモックオブジェクトを返すように設定
    mock_http = Minitest::Mock.new
    mock_http.expect :request, mock_response, [ Object ]

    Net::HTTP.stub :new, mock_http do
      # ジョブを実行
      assert_no_difference("Card.count") do
        CardIssuanceJob.perform_now(@card_application)
      end
    end
    mock_http.verify
  end
end
