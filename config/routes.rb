# frozen_string_literal: true

# config/routes.rb
#
# このファイルはアプリケーションのルーティングを定義します。
# ルーティングの詳細については、Railsガイドを参照してください:
# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # == 認証が必要なルート ==
  # カード申し込み用のルートを定義します。
  resources :card_applications, only: %i[new create]
  # 取引履歴表示用のルートを定義します。
  resources :transactions, only: [ :index ]
  # ユーザープロフィールページ用のルートを定義します。
  get "/profile", to: "users#show", as: :profile
  # ホームページ用のルートを定義します。
  get "home/index"
  # ユーザー認証用のルートを定義します。
  devise_for :users

  # == 認証が不要なルート ==
  # ヘルスチェック用のルートを定義します。
  get "up" => "rails/health#show", as: :rails_health_check
  # ルートパス('/')を定義します。
  root "home#index"

  # == API用のルート ==
  # API用のルートを定義します。
  namespace :api do
    namespace :v1 do
      # カード発行用のルートを定義します。
      post "cards/issue", to: "cards#issue"
    end
  end

  # == Webhook用のルート ==
  # Webhook受信用ルートを定義します。
  namespace :webhooks do
    # eKYCステータス更新受信用ルートを定義します。
    post "ekyc_statuses", to: "ekyc_statuses#create"
    # クレジットスコア更新受信用ルートを定義します。
    post "credit_scores", to: "credit_scores#create"
    # 申し込み結果更新受信用ルートを定義します。
    post "application_results", to: "application_results#create"
    # カード取引更新受信用ルートを定義します。
    post "card_transactions", to: "card_transactions#create"
  end
end
