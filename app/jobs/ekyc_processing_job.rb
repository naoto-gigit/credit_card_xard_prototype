require "net/http"
require "uri"

class EkycProcessingJob < ApplicationJob
  queue_as :default

  def perform(ekyc_application_id)
    ekyc_application = EkycApplication.find_by(id: ekyc_application_id)
    return unless ekyc_application

    Rails.logger.info "eKYC Processing Job for Application ID: #{ekyc_application.id} started."

    # 10秒待機
    sleep 10

    # 80%の確率で承認、20%の確率で拒否
    simulated_status = if rand(100) < 80
                         "approved"
    else
                         "rejected"
    end

    Rails.logger.info "eKYC Application ID: #{ekyc_application.id} simulated status: #{simulated_status}."

    # Webhookエンドポイントに結果を送信
    uri = URI.parse("http://localhost:3000/webhooks/ekyc_statuses") # URLを修正
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https" # For HTTPS if needed

    request = Net::HTTP::Post.new(uri.request_uri, "Content-Type" => "application/json")
    request.body = {
      ekyc_application_id: ekyc_application.id,
      status: simulated_status
    }.to_json

    begin
      response = http.request(request)
      Rails.logger.info "Webhook sent for eKYC Application ID: #{ekyc_application.id}. Response: #{response.code} #{response.message}"
    rescue StandardError => e
      Rails.logger.error "Failed to send webhook for eKYC Application ID: #{ekyc_application.id}: #{e.message}"
      # エラーハンドリング: 必要に応じて、ここでジョブのリトライや別の通知を行う
    end
  rescue StandardError => e
    Rails.logger.error "Error in EkycProcessingJob for Application ID: #{ekyc_application_id}: #{e.message}"
  end
end
