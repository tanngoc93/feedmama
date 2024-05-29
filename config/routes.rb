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
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

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
  get  "stripe/callback", to: "stripes#callback"
  post "stripe/webhook", to: "stripes#webhook"

  #
  get  "webhooks/:secured_token", to: "facebooks#subscription"
  post "webhooks/:secured_token", to: "facebooks#subscription"

  # 
  get "/settings", to: "user_settings#show", as: :user_settings
  put "/settings", to: "user_settings#update"

  # 
  get "social_accounts/facebook/code", to: "social_accounts#facebook_oauth"
  get "social_accounts/facebook/callback", to: "social_accounts#facebook_oauth_callback"

  get "social_accounts/instagram/code", to: "social_accounts#instagram_oauth"
  get "social_accounts/instagram/callback", to: "social_accounts#instagram_oauth_callback"

  #
  get "/pricing", to: "pages#pricing"
  get "/privacy_policy", to: "pages#privacy_policy"
  get "/terms_of_service", to: "pages#terms_of_service"

  # 
  root "homepage#index"
end
