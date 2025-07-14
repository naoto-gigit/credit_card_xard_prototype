require "test_helper"
require "rake"

class DelinquencyRakeTest < ActiveSupport::TestCase
  def setup
    CreditCardXardPrototype::Application.load_tasks
    @statement = statements(:one)
    # 支払期日を過去にする
    @statement.update!(due_date: Date.current - 1.day, status: "pending")
  end

  test "check_overdue task should update statement status to overdue" do
    assert_equal "pending", @statement.status

    Rake::Task["delinquency:check_overdue"].invoke

    @statement.reload
    assert_equal "overdue", @statement.status
  end
end
