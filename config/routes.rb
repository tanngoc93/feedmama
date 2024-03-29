Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  #
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #
  authenticate :admin_user do
    mount Sidekiq::Web => "/sidekiq"
  end

  # 
  devise_for :users,
    path: "",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      sign_up: "resgistration",
      edit: "profile"
    },
    controllers: {
      omniauth_callbacks: "omniauth_callbacks"
    }

  resources :orders
  resources :social_accounts

  #
  root "homepage#index"

  #
  get  "stripe/callback", to: "stripes#callback"
  post "stripe/webhook", to: "stripes#webhook"

  #
  get  "webhooks/:secured_token", to: "facebooks#subscription"
  post "webhooks/:secured_token", to: "facebooks#subscription"

  # 
  get "social_accounts/facebook/code", to: "social_accounts#facebook_oauth_code"
  get "social_accounts/facebook/callback", to: "social_accounts#facebook_oauth_callback"

  #
  get "/privacy_policy", to: "pages#privacy_policy"
  get "/terms_of_service", to: "pages#terms_of_service"
end
