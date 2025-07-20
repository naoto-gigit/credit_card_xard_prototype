# frozen_string_literal: true

module Api
  module V1
    # CardsController
    #
    # 外部のカード発行システム（Xard）のAPIモックです。
    # カード発行リクエストを受け取り、擬似的なカード情報を返します。
    class CardsController < ApplicationController
      # 外部からのAPIリクエストを受け付けるため、CSRF保護を無効にします。
      skip_before_action :verify_authenticity_token

      # POST /api/v1/cards/issue
      def issue
        # リクエストから所有者情報と限度額を取得
        owner_id = params[:owner_id]
        owner_type = params[:owner_type]
        credit_limit = params[:credit_limit]

        # パラメータが不足している場合はエラーを返す
        if owner_id.blank? || owner_type.blank? || credit_limit.blank?
          return render json: { error: "owner_id, owner_type, and credit_limit are required" }, status: :bad_request
        end

        # 擬似的なカード情報を生成
        xard_card_id = "crd_#{SecureRandom.hex(10)}"
        last_4_digits = rand(1000..9999).to_s
        card_type = [ "Visa", "Mastercard", "JCB" ].sample

        # 成功レスポンスを返す
        render json: {
          xard_card_id: xard_card_id,
          last_4_digits: last_4_digits,
          card_type: card_type,
          status: "active",
          issued_at: Time.current
        }, status: :created
      end
    end
  end
end
