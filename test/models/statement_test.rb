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
end
