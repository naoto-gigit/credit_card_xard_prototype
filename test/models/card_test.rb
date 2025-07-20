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
end
