require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  # --- 未ログイン時のテスト ---

  test "未ログイン状態でプロフィールページにアクセスすると、ログインページにリダイレクトされること" do
    get profile_url
    assert_redirected_to new_user_session_url
  end

  # --- ログイン時のテスト ---

  test "ログイン状態でプロフィールページにアクセスすると、正常に表示されること" do
    sign_in @user
    get profile_url
    assert_response :success
  end
end
