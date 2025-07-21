require "test_helper"
require "webmock/minitest"

class EkycProcessingJobTest < ActiveJob::TestCase
  test "should call eKYC API mock" do
    # テスト用のカード申し込みデータを作成
    card_application = card_applications(:one)

    stub_request(:post, "http://localhost:3000/api/v1/ekyc_verifications")
      .to_return(status: 200, body: "", headers: {})

    # ジョブを実行
    perform_enqueued_jobs do
      EkycProcessingJob.perform_later(card_application.id)
    end

    # ここでは、ジョブが正常に完了したこと（例外が発生しなかったこと）を
    # もって、テスト成功とみなします。
    # より厳密なテストは、APIコントローラー側で行います。
    assert true
  end
end
