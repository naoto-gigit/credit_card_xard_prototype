class UsersController < ApplicationController
  before_action :authenticate_user! # ログインしていないユーザーはアクセスできないようにする

  def show
    @user = current_user # 現在ログインしているユーザーの情報を取得
  end
end
