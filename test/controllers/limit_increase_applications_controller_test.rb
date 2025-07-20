require "test_helper"

class LimitIncreaseApplicationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @card = cards(:one)
    @user.cards << @card
    sign_in @user
  end

  test "should get new" do
    get new_card_limit_increase_application_url(@card)
    assert_response :success
  end

  test "should create limit increase application" do
    assert_difference("LimitIncreaseApplication.count") do
      post card_limit_increase_applications_url(@card), params: {
        limit_increase_application: {
          desired_limit: 100,
          start_date: Date.today,
          end_date: 1.month.from_now,
          reason: "海外旅行"
        }
      }
    end

    assert_redirected_to profile_url
    assert_equal "限度額の一時増額を申請しました。審査結果をお待ちください。", flash[:notice]
  end
end
