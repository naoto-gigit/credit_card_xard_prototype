require "test_helper"

class LimitIncreaseApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get limit_increase_applications_new_url
    assert_response :success
  end

  test "should get create" do
    get limit_increase_applications_create_url
    assert_response :success
  end
end
