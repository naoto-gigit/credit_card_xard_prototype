require "test_helper"

class CardApplicationTest < ActiveSupport::TestCase
  test "should belong to an applicant" do
    card_application = card_applications(:one)
    assert_instance_of User, card_application.applicant
  end
end
