require "test_helper"

class LimitIncreaseMailerTest < ActionMailer::TestCase
  setup do
    @application = limit_increase_applications(:one)
  end

  test "send_approval_email" do
    email = LimitIncreaseMailer.send_approval_email(@application)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "from@example.com" ], email.from
    assert_equal [ @application.user.email ], email.to
    assert_equal "【Xard】ご利用可能枠の一時的な増額が完了しました", email.subject
  end

  test "send_rejection_email" do
    email = LimitIncreaseMailer.send_rejection_email(@application)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "from@example.com" ], email.from
    assert_equal [ @application.user.email ], email.to
    assert_equal "【Xard】ご利用可能枠の一時的な増額申請の結果について", email.subject
  end
end
