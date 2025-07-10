class CreditScoringJob < ApplicationJob
  queue_as :default

  def perform(card_application_id)
    card_application = CardApplication.find_by(id: card_application_id)
    return unless card_application

    Rails.logger.info "Credit Scoring Job for Application ID: #{card_application.id} started."

    # シミュレートされた信用スコアを生成 (例: 300-850)
    simulated_credit_score = rand(300..850)

    Rails.logger.info "Card Application ID: #{card_application.id} simulated credit score: #{simulated_credit_score}."

    # 新しいWebhookエンドポイントに結果を送信
    uri = URI.parse("http://localhost:3000/webhooks/credit_scores")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    request = Net::HTTP::Post.new(uri.request_uri, "Content-Type" => "application/json")
    request.body = {
      card_application_id: card_application.id,
      credit_score: simulated_credit_score
    }.to_json

    begin
      response = http.request(request)
      Rails.logger.info "Webhook sent for Card Application ID: #{card_application.id}. Response: #{response.code} #{response.message}"
    rescue StandardError => e
      Rails.logger.error "Failed to send webhook for Card Application ID: #{card_application.id}: #{e.message}"
    end
  rescue StandardError => e
    Rails.logger.error "Error in CreditScoringJob for Application ID: #{card_application_id}: #{e.message}"
  end
end
