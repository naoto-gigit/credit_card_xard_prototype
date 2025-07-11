# frozen_string_literal: true

# UsersController
#
# このコントローラは、ユーザープロフィールに関連するリクエストを処理します。
class UsersController < ApplicationController
  # ユーザーがログインしていることを確認します。
  before_action :authenticate_user!

  # GET /profile
  # ユーザープロフィールページを表示します。
  def show
    # 現在ログインしているユーザーの情報を取得します。
    @user = current_user
    # ユーザーの最新のカード申し込みを取得します。
    @latest_card_application = @user.card_applications.order(created_at: :desc).first
  end
end
