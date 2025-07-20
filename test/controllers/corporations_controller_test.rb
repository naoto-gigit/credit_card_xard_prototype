require "test_helper"

class CorporationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get corporations_new_url
    assert_response :success
  end

  test "should get create" do
    get corporations_create_url
    assert_response :success
  end
end
