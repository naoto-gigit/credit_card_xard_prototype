# frozen_string_literal: true

require "test_helper"

class PointTransactionTest < ActiveSupport::TestCase
  test "should be valid with a User as point_owner" do
    pt = PointTransaction.new(
      point_owner: users(:one),
      points: 100
    )
    assert pt.valid?, pt.errors.full_messages.to_s
  end

  test "should be valid with a Corporation as point_owner" do
    pt = PointTransaction.new(
      point_owner: corporations(:one),
      points: 200
    )
    assert pt.valid?, pt.errors.full_messages.to_s
  end

  test "status should default to pending" do
    pt = PointTransaction.new(
      point_owner: users(:one),
      points: 10
    )
    assert_equal "pending", pt.status
  end
end
