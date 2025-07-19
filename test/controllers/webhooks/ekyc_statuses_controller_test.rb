require "test_helper"

class Webhooks::EkycStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card_application = card_applications(:one)
  end

  test "should enqueue CreditScoringJob when status is approved" do
    # テストアダプタを一時的に有効にする
    ActiveJob::Base.queue_adapter = :test

    # approvedのWebhookを受け取ると、CreditScoringJobが1件キューに追加されることを確認
    assert_enqueued_with(job: CreditScoringJob, args: [ @card_application.id ]) do
      post webhooks_ekyc_statuses_url, params: {
        card_application_id: @card_application.id,
        status: "approved"
      }
    end

    assert_response :success
  end

  test "should not enqueue CreditScoringJob when status is rejected" do
    # テストアダプタを一時的に有効にする
    ActiveJob::Base.queue_adapter = :test

    # rejectedのWebhookを受け取っても、ジョブが追加されないことを確認
    assert_no_enqueued_jobs(only: CreditScoringJob) do
      post webhooks_ekyc_statuses_url, params: {
        card_application_id: @card_application.id,
        status: "rejected"
      }
    end

    assert_response :success
  end
end
