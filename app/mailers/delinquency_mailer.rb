# frozen_string_literal: true

# DelinquencyMailer
#
# 支払いが延滞しているユーザーに督促メールを送信するためのメイラーです。
class DelinquencyMailer < ApplicationMailer
  # 支払いが延滞していることを通知するメール
  #
  # @param statement [Statement] 延滞している利用明細
  def overdue_reminder(statement)
    @statement = statement
    @user = @statement.user

    mail(to: @user.email, subject: "【重要】お支払いのお願い")
  end
end
