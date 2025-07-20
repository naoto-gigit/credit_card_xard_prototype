require "test_helper"

class CorporateCardApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get corporate_card_applications_new_url
    assert_response :success
  end

  test "should get create" do
    get corporate_card_applications_create_url
    assert_response :success
  end
end
