# frozen_string_literal: true

require "test_helper"
require "webmock/minitest" # WebMockをMinitestで使うために必要

class GrantCommunityPointsJobTest < ActiveJob::TestCase
  setup do
    @transaction = transactions(:one) # fixturesからテスト用の取引データを取得
  end

  test "should create a PointTransaction with status 'sent' on successful API call" do
    # 外部APIのエンドポイントをスタブ化し、成功レスポンスを返すように設定
    stub_request(:post, "http://localhost:3000/api/v1/community_points/grant")
      .to_return(status: 200, body: { status: "success" }.to_json, headers: { "Content-Type" => "application/json" })

    # ジョブを実行すると、PointTransactionレコードが1件増えることを確認
    assert_difference("PointTransaction.count", 1) do
      GrantCommunityPointsJob.perform_now(@transaction)
    end

    # 作成されたPointTransactionを取得
    point_transaction = PointTransaction.last

    # ステータスが'sent'にな���ていることを確認
    assert_equal "sent", point_transaction.status
    # ポイント数が正しく計算されていることを確認 (887 / 100 = 8)
    assert_equal 8, point_transaction.points
    # APIレスポンスが記録されていることを確認
    assert_equal({ "status" => "success" }.to_json, point_transaction.external_api_response)
    # 送信日時が記録されていることを確認
    assert_not_nil point_transaction.sent_at
  end

  test "should create a PointTransaction with status 'failed' on failed API call" do
    # 外部APIのエンドポイントをスタブ化し、失敗レスポンスを返すように設定
    stub_request(:post, "http://localhost:3000/api/v1/community_points/grant")
      .to_return(status: 500, body: { error: "Internal Server Error" }.to_json, headers: { "Content-Type" => "application/json" })

    # ジョブを実行すると、PointTransactionレコードが1件増えることを確認
    assert_difference("PointTransaction.count", 1) do
      # ジョブの実行によって例外が発生することを確認
      assert_raises(RuntimeError) do
        GrantCommunityPointsJob.perform_now(@transaction)
      end
    end

    # 作成されたPointTransactionを取得
    point_transaction = PointTransaction.last

    # ステータスが'failed'になっていることを確認
    assert_equal "failed", point_transaction.status
    # APIレスポンスが記録されていることを確認
    assert_equal({ "error" => "Internal Server Error" }.to_json, point_transaction.external_api_response)
    # 送信日時は記録されていないことを確認
    assert_nil point_transaction.sent_at
  end
end
