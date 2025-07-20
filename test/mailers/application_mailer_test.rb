# frozen_string_literal: true

require "test_helper"

class ApplicationMailerTest < ActionMailer::TestCase
  setup do
    @card_application = card_applications(:one)
  end

  test "send_approval_email" do
    email = ApplicationMailer.send_approval_email(@card_application)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "from@example.com" ], email.from
    assert_equal [ @card_application.applicant.email ], email.to
    assert_equal "【Xard】クレジットカード審査結果のお知らせ", email.subject
    assert_match "審査の結果、カードが承認されました", email.body.to_s
  end

  test "send_rejection_email" do
    email = ApplicationMailer.send_rejection_email(@card_application)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "from@example.com" ], email.from
    assert_equal [ @card_application.applicant.email ], email.to
    assert_equal "【Xard】クレジットカード審査結果のお知らせ", email.subject
    assert_match "今回はカードの発行を見送らせていただくことになりました", email.body.to_s
  end
end
