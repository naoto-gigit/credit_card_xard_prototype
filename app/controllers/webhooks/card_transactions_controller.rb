# frozen_string_literal: true

module Webhooks
  # CardTransactionsController
  #
  # 外部の決済システムからのWebhookを受け取り、カード利用履歴を作成するコントローラです。
  class CardTransactionsController < ApplicationController
    # 外部システムからのPOSTリクエストを受け付けるため、CSRF保護を無効にします。
    skip_before_action :verify_authenticity_token

    # POST /webhooks/card_transactions
    #
    # Webhookを受け取り、新しいTransactionレコードを作成します。
    def create
      Transaction.create!(transaction_params)
      head :ok
    end

    private

    # Strong Parameters
    #
    # マスアサインメント脆弱性を防ぐため、許可されたパラメータのみを受け取ります。
    def transaction_params
      params.require(:transaction).permit(:card_id, :merchant_name, :amount, :transacted_at)
    end
  end
end
