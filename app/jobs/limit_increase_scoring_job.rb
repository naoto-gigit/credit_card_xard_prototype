# frozen_string_literal: true

# LimitIncreaseScoringJob
#
# このジョブは、限度額増額申請の審査を非同期で実行します。
class LimitIncreaseScoringJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = LimitIncreaseApplication.find_by(id: application_id)
    return unless application

    Rails.logger.info "Limit Increase Scoring Job: Requesting scoring for Application ID: #{application.id}"

    # 外部の増額審査サービスAPI（モック）を呼び出す
    uri = URI.parse(Rails.application.routes.url_helpers.api_v1_limit_increase_scorings_url(host: "localhost", port: 3000))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request.body = { limit_increase_application_id: application.id }.to_json

    response = http.request(request)

    Rails.logger.info "Limit Increase Scoring API Response: #{response.code} #{response.message}"
  rescue StandardError => e
    Rails.logger.error "Error in LimitIncreaseScoringJob for Application ID: #{application_id}: #{e.message}"
  end
end
