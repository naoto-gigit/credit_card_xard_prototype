require "test_helper"
require "rake"

class DelinquencyRakeTest < ActiveSupport::TestCase
  def setup
    CreditCardXardPrototype::Application.load_tasks
    @statement = statements(:one)
    # 前提: 支払期日を過ぎた "pending" の明細を作成
    @statement.update!(due_date: Date.current.yesterday, status: "pending")
  end

  test "check_overdue task should update status to overdue" do
    # タスクを実行
    Rake::Task["delinquency:check_overdue"].invoke

    # 明細のステータスが "overdue" に更新されたことを確認
    assert_equal "overdue", @statement.reload.status
  end
end
