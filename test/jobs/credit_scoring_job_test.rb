require "test_helper"

class CreditScoringJobTest < ActiveJob::TestCase
  test "should call Credit Scoring API mock" do
    card_application = card_applications(:one)

    # ジョブがエラーなく実行されることをもって、シンプルにテストします。
    perform_enqueued_jobs do
      CreditScoringJob.perform_later(card_application.id)
    end

    assert true
  end
end
