require "net/http"
require "uri"

class EkycProcessingJob < ApplicationJob
  queue_as :default

  def perform(ekyc_application_id)
    card_application = CardApplication.find_by(id: ekyc_application_id)
    return unless card_application

    Rails.logger.info "eKYC Processing Job for Application ID: #{card_application.id} started."

    # 10秒待機
    sleep 10

    Rails.logger.info "eKYC Processing Job for Application ID: #{card_application.id} completed. Triggering CreditScoringJob."

    # eKYC処理が完了したら、次のステップとしてCreditScoringJobをキューに投入
    CreditScoringJob.perform_later(card_application.id)
  rescue StandardError => e
    Rails.logger.error "Error in EkycProcessingJob for Application ID: #{ekyc_application_id}: #{e.message}"
  end
end
