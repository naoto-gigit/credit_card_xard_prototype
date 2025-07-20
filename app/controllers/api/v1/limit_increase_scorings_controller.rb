# frozen_string_literal: true

require "net/http"
require "uri"

module Api
  module V1
    # LimitIncreaseScoringsController
    #
    # 増額審査サービスのAPI（モック）として機能するコントローラです。
    class LimitIncreaseScoringsController < ApplicationController
      skip_before_action :verify_authenticity_token

      # POST /api/v1/limit_increase_scorings
      def create
        application = LimitIncreaseApplication.find_by(id: params[:limit_increase_application_id])
        unless application
          return render json: { error: "LimitIncreaseApplication not found" }, status: :not_found
        end

        sleep 3 # 審査時間をシミュレート

        # 審査結果をシミュレート (80%の確率で承認)
        approved = rand(100) < 80
        status = approved ? "approved" : "rejected"
        approved_limit = approved ? application.desired_limit : 0

        send_webhook(application, status, approved_limit)

        render json: { message: "Limit increase scoring process started." }, status: :ok
      end

      private

      def send_webhook(application, status, approved_limit)
        webhook_url = Rails.application.routes.url_helpers.webhooks_limit_increase_results_url(host: "localhost:3000")
        payload = {
          limit_increase_application_id: application.id,
          status: status,
          approved_limit: approved_limit
        }.to_json

        uri = URI.parse(webhook_url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
        request.body = payload
        http.request(request)
      rescue StandardError => e
        Rails.logger.error "Failed to send Limit Increase Scoring webhook for Application ID: #{application.id}: #{e.message}"
      end
    end
  end
end
