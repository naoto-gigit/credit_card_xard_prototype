require "test_helper"

class StatementTest < ActiveSupport::TestCase
  setup do
    @statement = statements(:one)
  end

  #
  # Associations
  #
  test "should belong to a user" do
    assert_respond_to @statement, :user
    assert_instance_of User, @statement.user
  end

  test "should have many payments" do
    assert_respond_to @statement, :payments
    # 支払いがない場合もあるので、 first の存在は確認しない
  end

  #
  # Methods
  #
  test "#total_due_amount should return the sum of amount and late_payment_charge" do
    @statement.amount = 10000
    @statement.late_payment_charge = 146.50
    expected_total = 10146.50

    assert_equal expected_total, @statement.total_due_amount
  end

  test "#total_due_amount should return just the amount when late_payment_charge is zero" do
    @statement.amount = 10000
    @statement.late_payment_charge = 0

    assert_equal 10000, @statement.total_due_amount
  end
end
