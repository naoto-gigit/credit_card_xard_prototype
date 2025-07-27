require "test_helper"

class CorporateCardApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @corporation = corporations(:one)
    @user.update(corporation: @corporation)
    sign_in @user
  end

  test "should get new" do
    get new_corporation_card_application_url(@corporation)
    assert_response :success
  end

  test "should create corporate card application" do
    assert_difference("CardApplication.count") do
      post corporation_card_applications_url(@corporation), params: { card_application: { full_name: "Test Applicant" } }
    end

    assert_redirected_to profile_url
    assert_equal "法人カードの申し込みを受け付けました。審査が完了次第、結果をお知らせします。", flash[:notice]
    assert_equal @corporation, CardApplication.last.applicant
  end

  test "ログインユーザーは所属法人のカード申請詳細ページにアクセスできる" do
    # テスト用の申請データを作成し、所属法人に紐付ける
    application = card_applications(:one)
    application.update(applicant: @corporation)

    get corporation_card_application_url(@corporation, application)
    assert_response :success
  end

  test "他の法人のカード申請詳細ページにはアクセスできない" do
    # 他の法人と、その申請データを作成
    other_corporation = corporations(:two)
    other_application = card_applications(:two)
    other_application.update(applicant: other_corporation)

    # @userとしてログインした状態で、他の法人の申請ページにアクセス
    get corporation_card_application_url(other_corporation, other_application)
    # トップページにリダイレクトされることを期待
    assert_redirected_to root_url
  end
end
