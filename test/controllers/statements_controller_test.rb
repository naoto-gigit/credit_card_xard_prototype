require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @statement = statements(:one)
    @other_user_statement = statements(:two) # この明細は users(:two) に属します
  end

  # --- 未ログイン時のテスト ---

  test "未ログイン状態で一覧ページにアクセスすると、ログインページにリダイレクトされること" do
    get statements_url
    assert_redirected_to new_user_session_url
  end

  test "未ログイン状態で詳細ページにアクセスすると、ログインページにリダイレクトされること" do
    get statement_url(@statement)
    assert_redirected_to new_user_session_url
  end

  # --- ログイン時のテスト ---

  test "ログイン状態で一覧ページにアクセスすると、正常に表示されること" do
    sign_in @user
    get statements_url
    assert_response :success
  end

  test "ログイン状態で自身の詳細ページにアクセスすると、正常に表示されること" do
    sign_in @user
    get statement_url(@statement)
    assert_response :success
  end

  test "ログイン状態で他人の詳細ページにアクセスすると、トップページにリダイレクトされること" do
    sign_in @user
    get statement_url(@other_user_statement)
    assert_redirected_to root_url
  end
end
