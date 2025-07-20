# frozen_string_literal: true

module Webhooks
  # Webhooks::CreditScoresController
  #
  # 与信スコアの結果通知を受け取るWebhookコントローラです。
  class CreditScoresController < ApplicationController
    # CSRF保護をスキップします。
    skip_before_action :verify_authenticity_token

    # POST /webhooks/credit_scores
    def create
      Rails.logger.info "====== CreditScores Webhook Received ======"
      Rails.logger.info "Params: #{params.inspect}"

      card_application = CardApplication.find_by(id: params[:card_application_id])
      credit_score = params[:credit_score].to_i

      unless card_application
        render json: { error: "CardApplication not found" }, status: :not_found
        return
      end

      # スコアを保存
      card_application.update(credit_score: credit_score)

      # スコアに基づいて与信判断を行う（甘めの基準）
      decision, limit = decide_credit(credit_score)

      Rails.logger.info "Decision: #{decision}, Limit: #{limit}"

      # 審査結果と利用限度額を更新
      if card_application.update(
        credit_decision: decision,
        credit_limit: limit,
        status: "scoring_completed"
      )
        # ��認された場合はカード発行ジョブを起動
        if decision == "approved"
          CardIssuanceJob.perform_later(card_application)
        end

        render json: { message: "Credit score processed successfully." }, status: :ok
      else
        render json: { errors: card_application.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def decide_credit(score)
      # 承認ラインを450点に引き下げ
      if score >= 450
        decision = "approved"
        limit = calculate_limit(score)
      else
        decision = "rejected"
        limit = 0
      end
      [ decision, limit ]
    end

    def calculate_limit(score)
      case score
      when 450..599
        30  # 30万円
      when 600..749
        50  # 50万円
      when 750..850
        100 # 100万円
      else
        10  # 最低10万円
      end
    end
  end
end
