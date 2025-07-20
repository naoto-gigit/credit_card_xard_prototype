require "test_helper"
require "rake"

class PaymentRakeTest < ActiveSupport::TestCase
  def setup
    CreditCardXardPrototype::Application.load_tasks
    Rake::Task["payment:simulate_payments"].reenable
    @statement = statements(:one)
    @card = @statement.user.cards.first
    # 既存のPaymentをクリア
    Payment.destroy_all
  end

  test "simulate_payments task should pay due statements" do
    # 前提: 支払期日を過ぎた "pending" の明細を作成
    @statement.update!(due_date: Date.current.yesterday, status: "pending")

    # Paymentが1件作成されることを確認
    assert_difference("Payment.count", 1) do
      Rake::Task["payment:simulate_payments"].invoke
    end

    # 明細のステータスが "paid" に更新されたことを確認
    assert_equal "paid", @statement.reload.status
  end

  test "simulate_payments task should reactivate card if all dues are cleared" do
    # 前提: カードを一時停止状態にする
    @card.suspended!
    # 前提: 支払期日を過ぎた "overdue" の明細を作成
    @statement.update!(due_date: Date.current.yesterday, status: "overdue")
    # このユーザーに他の延滞明細がないことを確認
    assert_not @statement.user.statements.where(status: "overdue").where.not(id: @statement.id).exists?

    # タスクを実行
    Rake::Task["payment:simulate_payments"].invoke

    # カードのステータスが "active" に更新されたことを確認
    assert @card.reload.active?
  end
end
