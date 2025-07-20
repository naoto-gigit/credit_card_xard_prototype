# frozen_string_literal: true

# CardApplication
#
# クレジットカードの申し込みを表すモデルです。
class CardApplication < ApplicationRecord
  # 申し込みは個人(User)または法人(Corporation)に属します。
  belongs_to :applicant, polymorphic: true

  # credit_decisionが変更された後にメールを送信する
  after_update :send_decision_email, if: :saved_change_to_credit_decision?

  private

  def send_decision_email
    # credit_decisionがnilから値に変わった場合のみ送信（初回審査時）
    return if saved_change_to_credit_decision[0].present?

    if credit_decision == "approved"
      ApplicationMailer.send_approval_email(self).deliver_later
    else
      ApplicationMailer.send_rejection_email(self).deliver_later
    end
  end
end
