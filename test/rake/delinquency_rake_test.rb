# require "test_helper"
# require "rake"

# class DelinquencyRakeTest < ActiveSupport::TestCase
#   setup do
#     # Rakeタスクをロードし、テストで使えるようにする
#     CreditCardXardPrototype::Application.load_tasks
#   end

#   test "check_overdue task should update statement to overdue and suspend card for new delinquencies" do
#     statement = statements(:one)
#     card = statement.user.cards.first
#     statement.update!(due_date: Date.current.yesterday, status: "pending", late_payment_charge: 0)
#     card.active!

#     Rake::Task["delinquency:check_overdue"].reenable.invoke

#     assert_equal "overdue", statement.reload.status
#     assert card.reload.suspended?, "Card should be suspended"
#     assert_equal 0, statement.late_payment_charge, "Should not calculate charge on the first day of being overdue"
#   end

#   test "check_overdue task should calculate late payment charge for existing delinquencies" do
#     statement = statements(:one)
#     statement.update!(status: "overdue", amount: 10000, late_payment_charge: 0)
#     expected_daily_charge = (10000 * LATE_PAYMENT_INTEREST_RATE / 365).round(2)

#     Rake::Task["delinquency:check_overdue"].reenable.invoke

#     assert_equal expected_daily_charge, statement.reload.late_payment_charge

#     Rake::Task["delinquency:check_overdue"].reenable.invoke

#     assert_equal expected_daily_charge * 2, statement.reload.late_payment_charge
#   end
# end
