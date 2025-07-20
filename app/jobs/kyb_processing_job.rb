# frozen_string_literal: true

# KybProcessingJob
#
# このジョブは、法人カード申し込みの法人確認（KYB）を非同期で実行します。
class KybProcessingJob < ApplicationJob
  queue_as :default

  def perform(card_application_id)
    card_application = CardApplication.find_by(id: card_application_id)
    return unless card_application

    Rails.logger.info "KYB Processing Job: Requesting verification for Application ID: #{card_application.id}"

    # 外部の法人確認サービスAPI（モック）を呼び出す
    uri = URI.parse(Rails.application.routes.url_helpers.api_v1_kyb_verifications_url(host: "localhost", port: 3000))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = { card_application_id: card_application.id }.to_json

    response = http.request(request)

    Rails.logger.info "KYB API Response: #{response.code} #{response.message}"
  rescue StandardError => e
    Rails.logger.error "Error in KybProcessingJob for Application ID: #{card_application_id}: #{e.message}"
  end
end
