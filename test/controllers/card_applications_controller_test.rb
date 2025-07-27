require "test_helper"

class CardApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @card_application = card_applications(:one)
    # この申請がテストユーザーのものであることを保証する
    @card_application.update(applicant: @user)
    sign_in @user
  end

  test "ログインユーザーは個人カード申請ページにアクセスできる" do
    get new_card_application_url
    assert_response :success
  end

  test "ログインユーザーは自身の個人カード申請詳細ページにアクセスできる" do
    get card_application_url(@card_application)
    assert_response :success
  end

  test "他人の個人カード申請詳細ページにはアクセスできない" do
    # 他のユーザーを作成または取得
    other_user = users(:two)
    # 他のユーザーの申請を作成
    other_application = card_applications(:two)
    other_application.update(applicant: other_user)

    # @userとしてログインした状態で他人のページにアクセス
    get card_application_url(other_application)
    # 404 Not Foundが返ってくることを期待
    assert_response :not_found
  end
end
