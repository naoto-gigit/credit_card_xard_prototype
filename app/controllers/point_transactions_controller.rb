# frozen_string_literal: true

class PointTransactionsController < ApplicationController
  before_action :authenticate_user!

  # GET /point_transactions
  def index
    @point_transactions = PointTransaction.order(created_at: :desc)
  end
end
