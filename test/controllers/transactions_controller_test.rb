require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  # --- 未ログイン時のテスト ---

  test "未ログイン状態で取引履歴一覧ページにアクセスすると、ログインページにリダイレクトされること" do
    get transactions_url
    assert_redirected_to new_user_session_url
  end

  # --- ログイン時のテスト ---

  test "ログイン状態で取引履歴一覧ページにアクセスすると、正常に表示されること" do
    sign_in @user
    get transactions_url
    assert_response :success
  end
end
