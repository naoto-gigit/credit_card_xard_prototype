require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    sign_in users(:one) # テストユーザーをログインさせる
    get profile_url
    assert_response :success
  end
end
