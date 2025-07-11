# frozen_string_literal: true

# CreditScoringJob
#
# このジョブは、カード申し込みの与信スコアリングを非同期で実行します。
class CreditScoringJob < ApplicationJob
  # ジョブを `default` キューで実行します。
  queue_as :default

  # ジョブのメイン処理
  #
  # @param card_application_id [Integer] カード申し込みのID
  def perform(card_application_id)
    # カード申し込みを取得します。
    card_application = CardApplication.find_by(id: card_application_id)
    return unless card_application

    Rails.logger.info "Credit Scoring Job for Application ID: #{card_application.id} started."

    # 信用スコアをシミュレートします (例: 300-850)。
    simulated_credit_score = rand(300..850)

    Rails.logger.info "Card Application ID: #{card_application.id} simulated credit score: #{simulated_credit_score}."

    # Webhookエンドポイントに結果を送信します。
    uri = URI.parse("http://localhost:3000/webhooks/application_results")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    request = Net::HTTP::Post.new(uri.request_uri, "Content-Type" => "application/json")
    request.body = {
      card_application_id: card_application.id,
      credit_score: simulated_credit_score
    }.to_json

    begin
      # Webhookを送信します。
      response = http.request(request)
      Rails.logger.info "Webhook sent for Card Application ID: #{card_application.id}. Response: #{response.code} #{response.message}"
    rescue StandardError => e
      # Webhookの送信に失敗した場合は、エラーをログに記録します。
      Rails.logger.error "Failed to send webhook for Card Application ID: #{card_application.id}: #{e.message}"
    end
  rescue StandardError => e
    # ジョブの実行中にエラーが発生した場合は、エラーをログに記録します。
    Rails.logger.error "Error in CreditScoringJob for Application ID: #{card_application_id}: #{e.message}"
  end
end
