# frozen_string_literal: true

# frozen_string_literal: true

# TransactionsController
#
# 利用明細の表示を管理するコントローラです。
class TransactionsController < ApplicationController
  # ログインユーザーのみアクセスを許可します。
  before_action :authenticate_user!

  # GET /transactions
  #
  # ログインユーザーの利用明細一覧を表示します。
  def index
    @pagy, @transactions = pagy(current_user.transactions.order(transacted_at: :desc))
  end
end
