# frozen_string_literal: true

module Webhooks
  # ApplicationResultsController
  #
  # 外部の審査システムからの申し込み結果通知（Webhook）を受け取り、
  # カード申し込みのステータスを更新し、必要に応じてカードを発行するためのコントローラです。
  class ApplicationResultsController < ApplicationController
    # 外部システムからのPOSTリクエストを受け付けるため、CSRF保護を無効にします。
    skip_before_action :verify_authenticity_token

    # POST /webhooks/application_results
    #
    # Webhookを受け取り、カード申し込み結果を処理します。
    def create
      card_application_id = params[:card_application_id]
      credit_score = params[:credit_score]

      card_application = CardApplication.find_by(id: card_application_id)

      if card_application
        # クレジットスコアに基づいて審査結果（承認／否決）を決定します。
        credit_decision = credit_score >= 600 ? "承認" : "否決"

        # 承認された場合、クレジットスコアに応じて利用限度額を決定します。
        credit_limit = if credit_decision == "承認"
                         case credit_score
                         when 800.. then 100 # 800点以上: 100万円
                         when 700..799 then 50  # 700-799点: 50万円
                         when 600..699 then 30  # 600-699点: 30万円
                         else 0
                         end
        else
                         0
        end

        # カード申し込み情報を更新します。
        if card_application.update(credit_decision: credit_decision, credit_limit: credit_limit)
          # 承認された場合は、新しいカードを発行します。
          Card.create(user: card_application.user) if credit_decision == "承認"
          Rails.logger.info "Application results webhook processed for Card Application ID: #{card_application.id}. Decision: #{credit_decision}, Limit: #{credit_limit}"
          head :ok
        else
          Rails.logger.error "Failed to update Card Application ID: #{card_application.id}"
          render json: { error: "Failed to update card application." }, status: :unprocessable_entity
        end
      else
        Rails.logger.error "Card application not found for ID: #{card_application_id}"
        render json: { error: "Card application not found." }, status: :not_found
      end
    rescue StandardError => e
      Rails.logger.error "Error processing application results webhook for Card Application ID: #{card_application_id}: #{e.message}"
      render json: { error: "Internal server error." }, status: :internal_server_error
    end
  end
end
