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

      # 申請ステータスを更新
      application.update(status: status)

      if status == "approved"
        # 承認された場合は、カードの一時限度額を更新
        card = application.card
        card.update(
          temporary_limit: approved_limit,
          temporary_limit_expires_at: application.end_date.end_of_day
        )
        # TODO: 承認メールを送信
      else
        # TODO: 否決メールを送信
      end

      head :ok
    end
  end
end
