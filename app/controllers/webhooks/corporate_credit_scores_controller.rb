# frozen_string_literal: true

module Webhooks
  # CorporateCreditScoresController
  #
  # 法人向け与信スコアの結果通知を受け取るWebhookコントローラです。
  class CorporateCreditScoresController < ApplicationController
    # CSRF保護をスキップします。
    skip_before_action :verify_authenticity_token

    # POST /webhooks/corporate_credit_scores
    def create
      card_application = CardApplication.find_by(id: params[:card_application_id])
      credit_score = params[:credit_score].to_i

      unless card_application
        return render json: { error: "CardApplication not found" }, status: :not_found
      end

      # スコアを保存
      card_application.update(credit_score: credit_score)

      # スコアに基づいて与信判断を行う（法人向け基準）
      decision, limit = decide_credit(credit_score)

      # 審査結果と利用限度額を更新
      if card_application.update(
        credit_decision: decision,
        credit_limit: limit,
        status: "corporate_scoring_completed"
      )
        # 承認された場合はカード発行ジョブを起動
        if decision == "approved"
          CardIssuanceJob.perform_later(card_application)
        end

        render json: { message: "Corporate credit score processed successfully." }, status: :ok
      else
        render json: { errors: card_application.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def decide_credit(score)
      # 法人向けの承認ラインを450点に設定（個人向けと合わせる）
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
        50  # 50万円
      when 600..749
        100 # 100万円
      when 750..950
        300 # 300万円
      else
        30 # 最低30万円
      end
    end
  end
end
