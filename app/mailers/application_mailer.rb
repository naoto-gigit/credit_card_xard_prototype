class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def send_approval_email(card_application)
    @card_application = card_application
    mail(to: @card_application.user.email, subject: "【Xard】クレジットカード審査結果のお知らせ")
  end

  def send_rejection_email(card_application)
    @card_application = card_application
    mail(to: @card_application.user.email, subject: "【Xard】クレジットカード審査結果のお知らせ")
  end
end
