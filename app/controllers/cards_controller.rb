class CardsController < ApplicationController
  # ユーザーがログインしていることを確認します。
  before_action :authenticate_user!

  def index
    # 現在ログインしているユーザーの情報を取得します。
    @user = current_user
    # ユーザーの保有カードをすべて取得します。
    @cards = @user.cards.order(created_at: :desc)
    # ユーザーの個人向けカード申し込みをすべて取得します。(N+1問題対策)
    @card_applications = @user.card_applications.includes(:applicant).order(created_at: :desc)
    # ユーザーの法人向けカード申し込みをすべて取得します。(N+1問題対策)
    @corporate_card_applications = @user.corporation&.card_applications&.includes(:applicant)&.order(created_at: :desc) || []
  end
end
