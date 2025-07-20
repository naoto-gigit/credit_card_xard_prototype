# frozen_string_literal: true

require "net/http"
require "uri"

module Api
  module V1
    # KybVerificationsController
    #
    # 法人確認（KYB）サービスのAPI（モック）として機能するコントローラです。
    class KybVerificationsController < ApplicationController
      # 外部APIなので、CSRF保護をスキップします。
      skip_before_action :verify_authenticity_token

      # POST /api/v1/kyb_verifications
      def create
        card_application_id = params[:card_application_id]
        card_application = CardApplication.find_by(id: card_application_id)

        unless card_application
          return render json: { error: "CardApplication not found" }, status: :not_found
        end

        # 審査時間をシミュレートします。
        sleep 3 # 3秒待機

        # 審査結果をシミュレートします (例: 95%の確率で承認)
        simulated_result = rand(100) < 95 ? "approved" : "rejected"

        # Webhookを送信して、審査結果を通知します。
        send_webhook(card_application, simulated_result)

        # APIとしてのレスポンスを返します。
        render json: { message: "KYB verification process started. Webhook will be sent upon completion." }, status: :ok
      end

      private

      def send_webhook(card_application, result)
        webhook_url = Rails.application.routes.url_helpers.webhooks_kyb_statuses_url(host: "localhost:3000")
        payload = {
          card_application_id: card_application.id,
          status: result
        }.to_json

        uri = URI.parse(webhook_url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
        request.body = payload

        http.request(request)
      rescue StandardError => e
        Rails.logger.error "Failed to send KYB webhook for Application ID: #{card_application.id}: #{e.message}"
      end
    end
  end
end
