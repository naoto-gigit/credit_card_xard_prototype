require "test_helper"

class CardsControllerTest < ActionDispatch::IntegrationTest
  # Deviseのテストヘルパーをインクルード
  include Devise::Test::IntegrationHelpers

  setup do
    # テスト用のユーザーでサインインする
    sign_in users(:one)
  end

  test "ログインユーザーはカード管理ページにアクセスできる" do
    get cards_url
    assert_response :success
  end
end
