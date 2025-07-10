module Webhooks
  class EkycStatusesController < ApplicationController
    skip_before_action :verify_authenticity_token # WebhookはCSRFトークンなしで来るためスキップ

    def create
      ekyc_application_id = params[:ekyc_application_id]
      status = params[:status]

      card_application = CardApplication.find_by(id: ekyc_application_id)

      if card_application
        card_application.update(status: status)
        render json: { message: "eKYC application status updated successfully." }, status: :ok
      else
        render json: { error: "eKYC application not found." }, status: :not_found
      end
    rescue StandardError => e
      Rails.logger.error "Error processing eKYC status webhook: #{e.message}"
      render json: { error: "Internal server error." }, status: :internal_server_error
    end
  end
end
