# frozen_string_literal: true

require "net/http"
require "uri"

# EkycProcessingJob
#
# このジョブは、eKYC（オンライン本人確認）処理を非同期で実行します。
class EkycProcessingJob < ApplicationJob
  # ジョブを `default` キューで実行します。
  queue_as :default

  # ジョブのメイン処理
  #
  # @param ekyc_application_id [Integer] eKYC申し込みのID
  def perform(card_application_id)
    card_application = CardApplication.find_by(id: card_application_id)
    return unless card_application

    Rails.logger.info "eKYC Processing Job: Requesting verification for Application ID: #{card_application.id}"

    # 外部のeKYCサービスAPI（モック）を呼び出す
    uri = URI.parse("http://localhost:3000/api/v1/ekyc_verifications")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = { card_application_id: card_application.id }.to_json

    response = http.request(request)

    # レスポンスをログに出力
    Rails.logger.info "eKYC API Response: #{response.code} #{response.message}"
  rescue StandardError => e
    Rails.logger.error "Error in EkycProcessingJob for Application ID: #{card_application_id}: #{e.message}"
  end
end
