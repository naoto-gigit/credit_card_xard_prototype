# frozen_string_literal: true

module Webhooks
  # LimitIncreaseResultsController
  #
  # 増額審査の結果通知（Webhook）を受け取るコントローラです。
  class LimitIncreaseResultsController < ApplicationController
    skip_before_action :verify_authenticity_token

    # POST /webhooks/limit_increase_results
    def create
      application = LimitIncreaseApplication.find_by(id: params[:limit_increase_application_id])
      status = params[:status]
      approved_limit = params[:approved_limit].to_i

      unless application
        return render json: { error: "LimitIncreaseApplication not found" }, status: :not_found
      end

      # 申請ステータスと承認額を更新
      application.update(status: status, approved_limit: approved_limit)

      if status == "approved"
        # 承認された場合は、カードの一時限度額を更新
        card = application.card
        card.update(
          temporary_limit: approved_limit,
          temporary_limit_expires_at: application.end_date.end_of_day
        )
        LimitIncreaseMailer.send_approval_email(application).deliver_later
      else
        # 否決された場合は否決メールを送信
        LimitIncreaseMailer.send_rejection_email(application).deliver_later
      end

      head :ok
    end
  end
end
