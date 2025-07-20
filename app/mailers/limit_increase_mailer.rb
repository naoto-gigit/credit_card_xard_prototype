# frozen_string_literal: true

class LimitIncreaseMailer < ApplicationMailer
  # 増額申請が承認されたことを通知するメール
  def send_approval_email(application)
    @application = application
    @card = application.card
    @user = application.user

    mail(to: @user.email, subject: "【Xard】ご利用可能枠の一時的な増額が完了しました")
  end

  # 増額申請が否決されたことを通知するメール
  def send_rejection_email(application)
    @application = application
    @card = application.card
    @user = application.user

    mail(to: @user.email, subject: "【Xard】ご利用可能枠の一時的な増額申請の結果について")
  end
end
