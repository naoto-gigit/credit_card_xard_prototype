# frozen_string_literal: true

require "net/http"
require "uri"

# Api::V1::CreditScoringsController
#
# 与信スコアリングサービスのAPI（モック）として機能するコントローラです。
class Api::V1::CreditScoringsController < ApplicationController
  # 外部APIなので、CSRF保護をスキップします。
  skip_before_action :verify_authenticity_token

  # POST /api/v1/credit_scorings
  def create
    card_application_id = params[:card_application_id]
    card_application = CardApplication.find_by(id: card_application_id)

    unless card_application
      render json: { error: "CardApplication not found" }, status: :not_found
      return
    end

    # 審査時間をシミュレートします。
    sleep 3 # 3秒待機

    # 信用スコアをシミュレートします (例: 300-850)。
    simulated_credit_score = rand(300..850)

    # Webhookを送信して、審査結果を通知します。
    send_webhook(card_application, simulated_credit_score)

    # APIとしてのレスポンスを返します。
    render json: { message: "Credit scoring process started. Webhook will be sent upon completion." }, status: :ok
  end

  private

  def send_webhook(card_application, credit_score)
    webhook_url = Rails.application.routes.url_helpers.webhooks_credit_score_url(host: "localhost:3000")
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
    Rails.logger.error "Failed to send Credit Scoring webhook for Application ID: #{card_application.id}: #{e.message}"
  end
end
