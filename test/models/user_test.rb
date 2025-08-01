require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  #
  # Validations
  #
  test "should not save user without email" do
    user = User.new
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user with duplicate email" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase # 大文字小文字を区別しないことを確認
    assert_not duplicate_user.save, "Saved user with duplicate email"
  end

  #
  # Associations
  #
  test "should have many cards as owner" do
    assert_respond_to @user, :cards
    @user.cards.create!(xard_card_id: "test", last_4_digits: "1234")
    assert_instance_of Card, @user.cards.first
  end

  test "should have many statements" do
    assert_respond_to @user, :statements
    assert_instance_of Statement, @user.statements.first
  end

  test "should have many transactions through cards" do
    assert_respond_to @user, :transactions
    card = @user.cards.create!(xard_card_id: "test", last_4_digits: "1234")
    card.transactions.create!(merchant_name: "test", amount: 100)
    assert_instance_of Transaction, @user.transactions.first
  end
end
