require "test_helper"

class EkycApplicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ekyc_applications_new_url
    assert_response :success
  end

  test "should get create" do
    get ekyc_applications_create_url
    assert_response :success
  end
end
