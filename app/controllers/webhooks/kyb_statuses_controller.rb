# frozen_string_literal: true

module Webhooks
  # KybStatusesController
  #
  # 外部の法人確認システムからの結果通知（Webhook）を受け取るコントローラです。
  class KybStatusesController < ApplicationController
    # 外部システムからのPOSTリクエストを受け付けるため、CSRF保護を無効にします。
    skip_before_action :verify_authenticity_token

    # POST /webhooks/kyb_statuses
    def create
      card_application = CardApplication.find_by(id: params[:card_application_id])
      status = params[:status]

      unless card_application
        return render json: { error: "CardApplication not found" }, status: :not_found
      end

      # ステータスを更新
      card_application.update(status: "kyb_#{status}") # e.g., kyb_approved

      if status == "approved"
        # 承認された場合は、法人向けの与信審査ジョブを起動
        # TODO: CorporateCreditScoringJobを新規に作成し、呼び出す
        # CorporateCreditScoringJob.perform_later(card_application.id)
        Rails.logger.info "KYB approved for Application ID: #{card_application.id}. Triggering corporate credit scoring."
      else
        # 否決された場合は、否決メールを送信
        # TODO: 法人向けの否決メールを実装
        Rails.logger.info "KYB rejected for Application ID: #{card_application.id}."
      end

      head :ok
    end
  end
end
