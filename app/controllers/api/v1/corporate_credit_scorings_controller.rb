# frozen_string_literal: true

require "net/http"
require "uri"

module Api
  module V1
    # CorporateCreditScoringsController
    #
    # 法人向け与信スコアリングサービスのAPI（モック）として機能するコントローラです。
    class CorporateCreditScoringsController < ApplicationController
      # 外部APIなので、CSRF保護をスキップします。
      skip_before_action :verify_authenticity_token

      # POST /api/v1/corporate_credit_scorings
      def create
        card_application_id = params[:card_application_id]
        card_application = CardApplication.find_by(id: card_application_id)

        unless card_application
          return render json: { error: "CardApplication not found" }, status: :not_found
        end

        # 審査時間をシミュレートします。
        sleep 3 # 3秒待機

        # 法人向けの信用スコアをシミュレートします (例: 400-950)。
        simulated_credit_score = rand(400..950)

        # Webhookを送信して、審査結果を通知します。
        send_webhook(card_application, simulated_credit_score)

        # APIとしてのレスポンスを返します。
        render json: { message: "Corporate credit scoring process started. Webhook will be sent upon completion." }, status: :ok
      end

      private

      def send_webhook(card_application, credit_score)
        webhook_url = Rails.application.routes.url_helpers.webhooks_corporate_credit_scores_url(host: "localhost:3000")
        payload = {
          card_application_id: card_application.id,
          credit_score: credit_score
        }.to_json

        uri = URI.parse(webhook_url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
        request.body = payload

        http.request(request)
      rescue StandardError => e
        Rails.logger.error "Failed to send Corporate Credit Scoring webhook for Application ID: #{card_application.id}: #{e.message}"
      end
    end
  end
end
