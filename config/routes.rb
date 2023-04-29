Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "webhooks", to: "facebooks#subscription"
  post "webhooks", to: "facebooks#subscription"
end
