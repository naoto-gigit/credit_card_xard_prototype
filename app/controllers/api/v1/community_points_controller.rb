# frozen_string_literal: true

module Api
  module V1
    # 外部ポイントシステムAPIのモック
    class CommunityPointsController < ApplicationController
      # 外部からのAPI呼び出しなのでCSRF保護を無効化
      skip_before_action :verify_authenticity_token

      # POST /api/v1/community_points/grant
      def grant
        # ここでは、リクエストが来たという事実だけで成功とする
        # 本来はここでリクエスト内容を検証したりする
        Rails.logger.info "[MOCK] Community Points API: Received grant request with params: #{params.to_unsafe_h}"

        # 成功したことを示すJSONレスポンスを返す
        render json: { status: "success", message: "Points granted successfully." }, status: :ok
      end
    end
  end
end
