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
      card = Card.find_by(xard_card_id: params[:card_xard_id])

      if card
        # カードが有効（active）でない場合は、取引を拒否する
        unless card.active?
          head :unprocessable_entity
          return
        end

        transaction = Transaction.create!(
          card: card,
          merchant_name: params[:merchant_name],
          amount: params[:amount],
          transacted_at: params[:transacted_at]
        )

        # ポイント付与ジョブをキューに追加
        GrantCommunityPointsJob.perform_later(transaction)

        head :ok
      else
        head :not_found
      end
    end
  end
end
