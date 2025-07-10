Rails.application.routes.draw do
  resources :card_applications, only: [ :new, :create ]
  resources :transactions, only: [ :index ]
  get "/profile", to: "users#show", as: :profile
  get "home/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  namespace :api do
    namespace :v1 do
      post "cards/issue", to: "cards#issue"
    end
  end

  namespace :webhooks do
    post "ekyc_statuses", to: "ekyc_statuses#create"
    post "credit_scores", to: "credit_scores#create"
    post "application_results", to: "application_results#create"
    post "card_transactions", to: "card_transactions#create"
  end
end
