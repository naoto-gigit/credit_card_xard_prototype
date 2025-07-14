require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  setup do
    @payment = payments(:one)
  end

  #
  # Associations
  #
  test "should belong to a statement" do
    assert_respond_to @payment, :statement
    assert_instance_of Statement, @payment.statement
  end
end
