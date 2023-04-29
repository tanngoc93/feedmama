Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USER'] && password == ENV['SIDEKIQ_PASSWORD']
  end
  mount Sidekiq::Web => "/sidekiq"
  # 
  root "homepage#index"
  get  "webhooks/:secure_token", to: "facebooks#subscription"
  post "webhooks/:secure_token", to: "facebooks#subscription"
end
