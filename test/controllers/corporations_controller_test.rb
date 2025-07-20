require "test_helper"

class CorporationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get new" do
    get new_corporation_url
    assert_response :success
  end

  test "should create corporation" do
    assert_difference("Corporation.count") do
      post corporations_url, params: { corporation: { name: "New Corp", registration_number: "98765" } }
    end

    assert_redirected_to profile_url
    assert_equal "法人情報が登録されました。", flash[:notice]
    assert_equal "New Corp", @user.reload.corporation.name
  end
end
