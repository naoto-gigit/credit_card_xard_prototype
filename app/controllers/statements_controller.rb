# frozen_string_literal: true

# StatementsController
#
# 利用明細の表示を管理するコントローラーです。
class StatementsController < ApplicationController
  before_action :authenticate_user!

  # GET /statements
  # ログインユーザーの利用明細を一覧表示します。
  def index
    @statements = current_user.statements.order(billing_period_end_date: :desc)
  end

  # GET /statements/:id
  # 特定の利用明細を詳細表示します。
  def show
    @statement = current_user.statements.find_by(id: params[:id])

    if @statement.nil?
      redirect_to root_url, alert: "アクセス権がありません。"
    end
  end
end
