require "test_helper"

class DelinquencyMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  setup do
    # メーラーテストでURLヘルパーを使えるようにホストを設定
    Rails.application.routes.default_url_options[:host] = "localhost:3000"

    @statement = statements(:one)
    @mail = DelinquencyMailer.overdue_reminder(@statement)
  end

  test "renders the headers" do
    assert_equal "【重要】お支払いのお願い", @mail.subject
    assert_equal [ @statement.user.email ], @mail.to
    assert_equal [ "from@example.com" ], @mail.from
  end

  test "renders the body" do
    # HTMLパートとテキストパートの両方で本文を検証
    assert_match @statement.user.email, @mail.html_part.body.to_s
    assert_match @statement.amount.to_s, @mail.html_part.body.to_s
    assert_match statement_url(@statement), @mail.html_part.body.to_s

    assert_match @statement.user.email, @mail.text_part.body.to_s
    assert_match @statement.amount.to_s, @mail.text_part.body.to_s
    assert_match statement_url(@statement), @mail.text_part.body.to_s
  end
end
