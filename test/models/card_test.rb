require "test_helper"

class CardTest < ActiveSupport::TestCase
  setup do
    @card = cards(:one)
  end

  #
  # Associations
  #
  test "should belong to a user" do
    assert_respond_to @card, :user
    assert_instance_of User, @card.user
  end

  test "should have many transactions" do
    assert_respond_to @card, :transactions
    assert_instance_of Transaction, @card.transactions.first
  end
end
