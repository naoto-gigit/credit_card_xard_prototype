require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @transaction = transactions(:one)
  end

  #
  # Associations
  #
  test "should belong to a card" do
    assert_respond_to @transaction, :card
    assert_instance_of Card, @transaction.card
  end

  test "should belong to an owner through card" do
    assert_respond_to @transaction, :owner
    assert_instance_of User, @transaction.owner
  end
end
