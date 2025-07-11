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
  def perform(ekyc_application_id)
    # カード申し込みを取得します。
    card_application = CardApplication.find_by(id: ekyc_application_id)
    return unless card_application

    Rails.logger.info "eKYC Processing Job for Application ID: #{card_application.id} started."

    # 10秒待機して、eKYC処理をシミュレートします。
    sleep 10

    Rails.logger.info "eKYC Processing Job for Application ID: #{card_application.id} completed. Triggering CreditScoringJob."

    # eKYC処理が完了したら、次のステップとしてCreditScoringJobをキューに投入します。
    CreditScoringJob.perform_later(card_application.id)
  rescue StandardError => e
    # ジョブの実行中にエラーが発生した場合は、エラーをログに記録します。
    Rails.logger.error "Error in EkycProcessingJob for Application ID: #{ekyc_application_id}: #{e.message}"
  end
end
