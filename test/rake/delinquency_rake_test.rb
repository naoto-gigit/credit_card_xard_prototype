require "test_helper"
require "rake"

class DelinquencyRakeTest < ActiveSupport::TestCase
  setup do
    # Rakeタスクをロード
    CreditCardXardPrototype::Application.load_tasks
  end

  test "check_overdue task should update statement to overdue and suspend card for new delinquencies" do
    # このテスト用のデータを準備
    statement = statements(:one)
    card = statement.user.cards.first
    statement.update!(due_date: Date.current.yesterday, status: "pending")
    card.active!

    # タスクを再実行可能にする
    Rake::Task["delinquency:check_overdue"].reenable
    # タスクを実行
    Rake::Task["delinquency:check_overdue"].invoke

    # 検証: 明細が "overdue" に、カードが "suspended" になること
    assert_equal "overdue", statement.reload.status
    assert card.reload.suspended?, "Card should be suspended"
  end

  test "check_overdue task should calculate late payment charge for existing delinquencies" do
    # このテスト用のデータを準備
    statement = statements(:one)
    statement.update!(status: "overdue", amount: 10000, late_payment_charge: 0)
    expected_daily_charge = (10000 * LATE_PAYMENT_INTEREST_RATE / 365).round(2)

    # タスクを再実行可能にする
    Rake::Task["delinquency:check_overdue"].reenable
    # タスクを実行
    Rake::Task["delinquency:check_overdue"].invoke

    # 検証: 遅延損害金が1日分加算されること
    assert_equal expected_daily_charge, statement.reload.late_payment_charge

    # もう一度タスクを実行
    Rake::Task["delinquency:check_overdue"].reenable
    Rake::Task["delinquency:check_overdue"].invoke

    # 検証: 遅延損害金がさらに1日分加算されること（合計2日分）
    assert_equal expected_daily_charge * 2, statement.reload.late_payment_charge
  end
end
