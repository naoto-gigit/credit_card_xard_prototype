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
end
