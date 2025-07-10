class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions.order(transacted_at: :desc)
  end
end
