require "test_helper"
require "rake"

class PaymentRakeTest < ActiveSupport::TestCase
  def setup
    CreditCardXardPrototype::Application.load_tasks
    @statement = statements(:one)
    # 前提: 支払期日を過ぎた "pending" の明細を作成
    @statement.update!(due_date: Date.current.yesterday, status: "pending")
    # 既存のPaymentをクリア
    Payment.destroy_all
  end

  test "simulate_payments task should pay due statements" do
    # Paymentが1件作成されることを確認
    assert_difference("Payment.count", 1) do
      Rake::Task["payment:simulate_payments"].invoke
    end

    # 明細のステータスが "paid" に更新されたことを確認
    assert_equal "paid", @statement.reload.status
  end
end
