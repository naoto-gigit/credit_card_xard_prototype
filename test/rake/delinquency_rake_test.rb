require "test_helper"
require "rake"

class DelinquencyRakeTest < ActiveSupport::TestCase
  def setup
    CreditCardXardPrototype::Application.load_tasks
    Rake::Task["delinquency:check_overdue"].reenable
    @statement = statements(:one)
    @card = @statement.user.cards.first
    # 前提: 支払期日を過ぎた "pending" の明細を作成
    @statement.update!(due_date: Date.current.yesterday, status: "pending")
    # 前提: カードは "active" な状態
    @card.active!
  end

  test "check_overdue task should update statement to overdue and suspend card" do
    # タスクを実行
    Rake::Task["delinquency:check_overdue"].invoke

    # 明細のステータスが "overdue" に更新されたことを確認
    assert_equal "overdue", @statement.reload.status
    # カードのステータスが "suspended" に更新されたことを確認
    assert @card.reload.suspended?
  end
end
