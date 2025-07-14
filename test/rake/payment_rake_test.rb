require "test_helper"
require "rake"

class PaymentRakeTest < ActiveSupport::TestCase
  def setup
    CreditCardXardPrototype::Application.load_tasks
    @statement = statements(:one)
    # 支払期日を過去にする
    @statement.update!(due_date: Date.current - 1.day, status: "pending")
    # 既存のPaymentをクリア
    Payment.destroy_all
  end

  test "simulate_payments task should create a payment and update statement status" do
    assert_equal "pending", @statement.status
    assert_equal 0, Payment.count

    Rake::Task["payment:simulate_payments"].invoke

    @statement.reload
    assert_equal "paid", @statement.status
    assert_equal 1, Payment.count
    payment = Payment.first
    assert_equal @statement, payment.statement
    assert_equal @statement.amount, payment.amount
  end
end
