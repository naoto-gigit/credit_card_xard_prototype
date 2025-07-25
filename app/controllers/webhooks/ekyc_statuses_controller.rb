# frozen_string_literal: true

module Webhooks
  # EkycStatusesController
  #
  # このコントローラは、eKYCステータスの更新に関するWebhookを処理します。
  class EkycStatusesController < ApplicationController
    # WebhookはCSRFトークンなしで送信されるため、CSRFトークンの検証をスキップします。
    skip_before_action :verify_authenticity_token

    # POST /webhooks/ekyc_statuses
    # eKYCステータスの更新を受け取ります。
    def create
      card_application_id = params[:card_application_id]
      status = params[:status]

      card_application = CardApplication.find_by(id: card_application_id)

      if card_application
        # カード申し込みのステータスを更新します。
        card_application.update(status: "ekyc_#{status}") # e.g., ekyc_approved

        # eKYCが承認された場合、次の与信審査ジョブをキューに追加します。
        if status == "approved"
          CreditScoringJob.perform_later(card_application.id)
        end

        # 成功レスポンスを返します。
        render json: { message: "eKYC application status updated successfully." }, status: :ok
      else
        # カード申し込みが見つからない場合は、エラーレスポンスを返します。
        render json: { error: "eKYC application not found." }, status: :not_found
      end
    rescue StandardError => e
      # エラー処理
      Rails.logger.error "Error processing eKYC status webhook: #{e.message}"
      render json: { error: "Internal server error." }, status: :internal_server_error
    end
  end
end
