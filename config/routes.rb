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
  root "homepage#index"
  get  "webhooks/:secured_token", to: "facebooks#subscription"
  post "webhooks/:secured_token", to: "facebooks#subscription"
end
