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
    # ログインユーザーの全取引を取得し、取引日時の降順で並び替えます。
    @transactions = current_user.transactions.order(transacted_at: :desc)
  end
end
