class UsersController < ApplicationController
  before_action :authenticate_user! # ログインしていないユーザーはアクセスできないようにする

  def show
    @user = current_user # 現在ログインしているユーザーの情報を取得
    @latest_card_application = @user.card_applications.order(created_at: :desc).first
  end
end
