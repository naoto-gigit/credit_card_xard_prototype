require "test_helper"

class Webhooks::CreditScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card_application = card_applications(:one)
  end

  test "should update card application with approved status and limit" do
    # 承認されるスコアを送信
    approved_score = 700
    post webhooks_credit_scores_url, params: {
      card_application_id: @card_application.id,
      credit_score: approved_score
    }

    assert_response :success

    # データベースの値が正しく更新されたか確認
    @card_application.reload
    assert_equal approved_score, @card_application.credit_score
    assert_equal "approved", @card_application.credit_decision
    assert_equal 50, @card_application.credit_limit # 700点なら50万円
  end

  test "should update card application with rejected status" do
    # 否決されるスコアを送信
    rejected_score = 400
    post webhooks_credit_scores_url, params: {
      card_application_id: @card_application.id,
      credit_score: rejected_score
    }

    assert_response :success

    # データベースの値が正しく更新されたか確認
    @card_application.reload
    assert_equal rejected_score, @card_application.credit_score
    assert_equal "rejected", @card_application.credit_decision
    assert_equal 0, @card_application.credit_limit
  end
end
