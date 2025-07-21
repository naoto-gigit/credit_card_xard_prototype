# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

# 外部ポイントシステムにポイント付与を依頼する非同期ジョブ
class GrantCommunityPointsJob < ApplicationJob
  queue_as :default

  # @param transaction [Transaction] ポイント付与の元となるカード取引
  def perform(transaction)
    point_transaction = PointTransaction.create!(
      point_owner: transaction.card.owner,
      source_transaction: transaction,
      points: calculate_points(transaction.amount),
      status: "pending"
    )

    # credentials を使わず、開発用の設定を直接記述
    endpoint = "http://localhost:3000/api/v1/community_points/grant"
    api_key = "dummy-dev-key"

    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = {
      user_id: point_transaction.point_owner_id,
      user_type: point_transaction.point_owner_type,
      points: point_transaction.points,
      description: "クレジットカード利用によるポイント付与",
      idempotency_key: point_transaction.id
    }.to_json

    response = http.request(request)
    response_body = response.body

    if response.is_a?(Net::HTTPSuccess)
      point_transaction.update!(
        status: "sent",
        sent_at: Time.current,
        external_api_response: response_body
      )
      Rails.logger.info "Successfully granted points for PointTransaction ##{point_transaction.id}"
    else
      point_transaction.update!(
        status: "failed",
        external_api_response: response_body
      )
      Rails.logger.error "Failed to grant points for PointTransaction ##{point_transaction.id}. Response: #{response.code}"
      raise "API request failed with status #{response.code}"
    end
  end

  private

  def calculate_points(amount)
    (amount / 100).floor
  end
end
