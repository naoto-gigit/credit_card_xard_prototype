# frozen_string_literal: true

# CreditScoringJob
#
# このジョブは、カード申し込みの与信スコアリングを非同期で実行します。
class CreditScoringJob < ApplicationJob
  queue_as :default

  def perform(card_application_id)
    card_application = CardApplication.find_by(id: card_application_id)
    return unless card_application

    Rails.logger.info "Credit Scoring Job: Requesting scoring for Application ID: #{card_application.id}"

    # 外部の与信スコアリングサービスAPI（モック）を呼び出す
    uri = URI.parse("http://localhost:3000/api/v1/credit_scorings")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    # 審査に必要な情報を送信する（例：申し込みID）
    request.body = { card_application_id: card_application.id }.to_json

    response = http.request(request)

    Rails.logger.info "Credit Scoring API Response: #{response.code} #{response.message}"
  rescue StandardError => e
    Rails.logger.error "Error in CreditScoringJob for Application ID: #{card_application_id}: #{e.message}"
  end
end
