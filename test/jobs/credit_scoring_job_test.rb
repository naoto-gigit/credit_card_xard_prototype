require "test_helper"
require "webmock/minitest"

class CreditScoringJobTest < ActiveJob::TestCase
  test "should call Credit Scoring API mock" do
    card_application = card_applications(:one)

    stub_request(:post, "http://localhost:3000/api/v1/credit_scorings")
      .to_return(status: 200, body: "", headers: {})

    # ジョブがエラーなく実行されることをもって、シンプルにテストします。
    perform_enqueued_jobs do
      CreditScoringJob.perform_later(card_application.id)
    end

    assert true
  end
end
