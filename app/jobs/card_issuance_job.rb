# frozen_string_literal: true

# CardIssuanceJob
#
# カード発行を非同期で処理するジョブです。
# 外部のカード発行APIと連携し、成功したらカード情報をデータベースに保存します。
class CardIssuanceJob < ApplicationJob
  queue_as :default

  def perform(card_application)
    Rails.logger.info "CardIssuanceJob: Started for Card Application ID: #{card_application.id}"

    # APIエンドポイントのURLを構築
    # Rails.application.routes.url_helpers を使ってルーティングからURLを生成
    # host, port は環境に応じて設定が必要
    uri = URI.parse(Rails.application.routes.url_helpers.api_v1_cards_issue_url(host: "localhost", port: 3000))

    # HTTPリクエストを準備
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = {
      user_id: card_application.applicant_id,
      credit_limit: card_application.credit_limit
    }.to_json

    # リクエストを送信し、レスポンスを受け取る
    response = http.request(request)

    # レスポンスが成功した場合
    if response.is_a?(Net::HTTPSuccess)
      # JSONレスポンスをパース
      card_data = JSON.parse(response.body)

      # 受け取ったデータでCardレコードを作成
      Card.create!(
        user: card_application.applicant,
        xard_card_id: card_data["xard_card_id"],
        last_4_digits: card_data["last_4_digits"],
        card_type: card_data["card_type"],
        status: card_data["status"],
        issued_at: card_data["issued_at"]
      )
      Rails.logger.info "CardIssuanceJob: Successfully issued card for Card Application ID: #{card_application.id}"
    else
      # エラー処理
      Rails.logger.error "CardIssuanceJob: Failed to issue card for Card Application ID: #{card_application.id}. Response: #{response.body}"
    end
  rescue StandardError => e
    Rails.logger.error "CardIssuanceJob: Error for Card Application ID: #{card_application.id}: #{e.message}"
  end
end
