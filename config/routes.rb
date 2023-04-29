Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "homepage#index"
  get  "webhooks/:secure_token", to: "facebooks#subscription"
  post "webhooks/:secure_token", to: "facebooks#subscription"
end
