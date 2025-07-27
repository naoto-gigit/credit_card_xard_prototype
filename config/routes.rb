# frozen_string_literal: true

# config/routes.rb
#
# このファイルはアプリケーションのルーティングを定義します。
# ルーティングの詳細については、Railsガイドを参照してください:
# https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # letter_opener_web用のルーティング (開発環境のみ)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # == 認証が必要なルート ==
  # 法人登録用のルートを定義します。
  resources :corporations, only: %i[new create] do
    # 法人カード申し込み用のルート（ネスト）
    resources :card_applications, only: %i[new create show], controller: "corporate_card_applications"
  end
  # 個人カード申し込み用のルートを定義します。
  resources :card_applications, only: %i[new create show]

  # カード関連（増額申請など）のルートを定義します。
  resources :cards, only: [ :index ] do
    resources :limit_increase_applications, only: %i[new create]
  end
  # 取引履歴表示用のルートを定義します。
  resources :transactions, only: [ :index ]
  # ポイント取引履歴表示用のルートを定義します。
  resources :point_transactions, only: [ :index ]
  # 利用明細表示用のルートを定義します。
  resources :statements, only: %i[index show]
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
      # eKYC検証リクエスト受信用ルートを定義します。
      post "ekyc_verifications", to: "ekyc_verifications#create"
      # KYB検証リクエスト受信用ルートを定義します。
      post "kyb_verifications", to: "kyb_verifications#create"
      # 与信スコアリングリクエスト受信用ルートを定義します。
      post "credit_scorings", to: "credit_scorings#create"
      # 法人向け与信スコアリングリクエスト受信用ルートを定義します。
      post "corporate_credit_scorings", to: "corporate_credit_scorings#create"
      # 増額申請審査リクエスト受信用ルートを定義します。
      post "limit_increase_scorings", to: "limit_increase_scorings#create"
      # カード発行用のルートを定義します。
      post "cards/issue", to: "cards#issue"

      # ポイント付与用のルートを定義します。（モック）
      post "community_points/grant", to: "community_points#grant"
    end
  end

  # == Webhook用のルート ==
  # Webhook受信用ルートを定義します。
  namespace :webhooks do
    # eKYCステータス更新受信用ルートを定義します。
    post "ekyc_statuses", to: "ekyc_statuses#create"
    # KYBステータス更新受信用ルートを定義します。
    post "kyb_statuses", to: "kyb_statuses#create"
    # クレジットスコア更新受信用ルートを定義します。
    post "credit_scores", to: "credit_scores#create"
    # 法人向けクレジットスコア更新受信用ルートを定義します。
    post "corporate_credit_scores", to: "corporate_credit_scores#create"
    # 増額申請結果更新受信用ルートを定義します。
    post "limit_increase_results", to: "limit_increase_results#create"
    # カード取引更新受信用ルートを定義します。
    post "card_transactions", to: "card_transactions#create"
  end
end
