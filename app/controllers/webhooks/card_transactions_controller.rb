class Webhooks::CardTransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Transaction.create!(transaction_params)
    head :ok
  end

  private

  def transaction_params
    params.require(:transaction).permit(:card_id, :merchant_name, :amount, :transacted_at)
  end
end
