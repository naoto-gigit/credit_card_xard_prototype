require "test_helper"

class CardTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @corporation = corporations(:one)
  end

  test "should be valid with a user as owner" do
    card = Card.new(owner: @user, xard_card_id: "test_id", last_4_digits: "1234")
    assert card.valid?
  end

  test "should be valid with a corporation as owner" do
    card = Card.new(owner: @corporation, xard_card_id: "test_id", last_4_digits: "1234")
    assert card.valid?
  end

  test "should be invalid without an owner" do
    card = Card.new(xard_card_id: "test_id", last_4_digits: "1234")
    assert_not card.valid?
  end

  test "#current_credit_limit returns temporary_limit when active" do
    @user.cards.update(credit_limit: 50, temporary_limit: 100, temporary_limit_expires_at: 1.day.from_now)
    assert_equal 100, @user.cards.first.current_credit_limit
  end

  test "#current_credit_limit returns credit_limit when temporary_limit is expired" do
    @user.cards.update(credit_limit: 50, temporary_limit: 100, temporary_limit_expires_at: 1.day.ago)
    assert_equal 50, @user.cards.first.current_credit_limit
  end

  test "#current_credit_limit returns credit_limit when temporary_limit is nil" do
    @user.cards.update(credit_limit: 50, temporary_limit: nil, temporary_limit_expires_at: nil)
    assert_equal 50, @user.cards.first.current_credit_limit
  end
end
