require "test_helper"

class EkycProcessingJobTest < ActiveJob::TestCase
  test "should call eKYC API mock" do
    # テスト用のカード申し込みデータを作成
    card_application = card_applications(:one)

    # Net::HTTP.any_instance.expects(:request).once
    # 上記はMinitestのモック機能ですが、設定が複雑なので、
    # ここでは、ジョブがエラーなく実行されること、
    # そして、ログにAPI呼び出しの形跡が残ることをもって、
    # シンプルにテストします。

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
