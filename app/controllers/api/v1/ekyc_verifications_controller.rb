# frozen_string_literal: true

require "net/http"
require "uri"

# Api::V1::EkycVerificationsController
#
# eKYCサービスのAPI（モック）として機能するコントローラです。
class Api::V1::EkycVerificationsController < ApplicationController
  # 外部APIなので、CSRF保護をスキップします。
  skip_before_action :verify_authenticity_token

  # POST /api/v1/ekyc_verifications
  def create
    # パラメータからカード申し込みIDを取得します。
    card_application_id = params[:card_application_id]
    card_application = CardApplication.find_by(id: card_application_id)

    unless card_application
      render json: { error: "CardApplication not found" }, status: :not_found
      return
    end

    # 審査時間をシミュレートします。
    sleep 5 # 5秒待機

    # 審査結果をランダムに決定します（例: 80%の確率で承認）。
    status = rand < 0.8 ? "approved" : "rejected"

    # Webhookを送信して、審査結果を通知します。
    send_webhook(card_application, status)

    # APIとしてのレスポンスを返します。
    render json: { message: "eKYC verification process started. Webhook will be sent upon completion." }, status: :ok
  end

  private

  def send_webhook(card_application, status)
    # Webhookの送信先URLを取得します。
    webhook_url = Rails.application.routes.url_helpers.webhooks_ekyc_statuses_url(host: "localhost:3000")

    # Webhookで送信するデータ（ペイロード）を作成します。
    payload = {
      card_application_id: card_application.id,
      status: status,
      verified_at: Time.current
    }.to_json

    # HTTPクライアントを使って、Webhookを送信します。
    uri = URI.parse(webhook_url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = payload

    # 同期的にリクエストを送信します。
    http.request(request)
  rescue StandardError => e
    Rails.logger.error "Failed to send eKYC webhook for Application ID: #{card_application.id}: #{e.message}"
  end
end
