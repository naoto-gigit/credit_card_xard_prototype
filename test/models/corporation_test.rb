require "test_helper"

class CorporationTest < ActiveSupport::TestCase
  test "should be valid with a name" do
    corporation = Corporation.new(name: "Test Corp", registration_number: "12345")
    assert corporation.valid?
  end

  test "should be invalid without a name" do
    corporation = Corporation.new(registration_number: "12345")
    assert_not corporation.valid?
  end
end
