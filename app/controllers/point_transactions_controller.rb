# frozen_string_literal: true

class PointTransactionsController < ApplicationController
  before_action :authenticate_user!

  # GET /point_transactions
  def index
    @pagy, @point_transactions = pagy(PointTransaction.where(point_owner: current_user).order(created_at: :desc))
  end
end
