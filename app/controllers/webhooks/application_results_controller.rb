module Webhooks
  class ApplicationResultsController < ApplicationController
    skip_before_action :verify_authenticity_token # WebhookではCSRFトークン検証をスキップ

    def create
      card_application_id = params[:card_application_id]
      credit_score = params[:credit_score]

      card_application = CardApplication.find_by(id: card_application_id)

      if card_application
        # シンプルな自動審査ロジック
        credit_decision = if credit_score >= 600
                            "承認"
        else
                            "否決"
        end

        # 利用限度額の決定 (例: スコアに応じて)
        credit_limit = if credit_decision == "承認"
                         case credit_score
                         when 800.. then 100
                         when 700..799 then 50
                         when 600..699 then 30
                         else 0 # 承認されない場合は0
                         end
        else
                         0 # 否決の場合は0
        end

        if card_application.update(credit_decision: credit_decision, credit_limit: credit_limit)
          if credit_decision == "承認"
            Card.create(user: card_application.user)
          end
          Rails.logger.info "Application results webhook processed for Card Application ID: #{card_application.id}. Decision: #{credit_decision}, Limit: #{credit_limit}"
          head :ok
        else
          # 更新に失敗した場合の処理
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
