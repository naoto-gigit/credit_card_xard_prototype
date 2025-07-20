require "test_helper"

class LimitIncreaseApplicationTest < ActiveSupport::TestCase
  setup do
    @application = limit_increase_applications(:one)
  end

  test "should belong to a card" do
    assert_respond_to @application, :card
    assert_instance_of Card, @application.card
  end

  test "should belong to a user" do
    assert_respond_to @application, :user
    assert_instance_of User, @application.user
  end
end
