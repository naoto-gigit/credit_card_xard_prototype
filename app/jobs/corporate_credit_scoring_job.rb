# frozen_string_literal: true

# CorporateCreditScoringJob
#
# このジョブは、法人カード申し込みの与信スコアリングを非同期で実行します。
class CorporateCreditScoringJob < ApplicationJob
  queue_as :default

  def perform(card_application_id)
    card_application = CardApplication.find_by(id: card_application_id)
    return unless card_application

    Rails.logger.info "Corporate Credit Scoring Job: Requesting scoring for Application ID: #{card_application.id}"

    # 外部の法人向け与信スコアリングサービスAPI（モック）を呼び出す
    uri = URI.parse(Rails.application.routes.url_helpers.api_v1_corporate_credit_scorings_url(host: "localhost", port: 3000))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = { card_application_id: card_application.id }.to_json

    response = http.request(request)

    Rails.logger.info "Corporate Credit Scoring API Response: #{response.code} #{response.message}"
  rescue StandardError => e
    Rails.logger.error "Error in CorporateCreditScoringJob for Application ID: #{card_application_id}: #{e.message}"
  end
end
