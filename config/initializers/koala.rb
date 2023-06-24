# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.access_token     = ENV.fetch("KOALA_ACCESS_TOKEN") { SecureRandom.hex }
  config.app_access_token = ENV.fetch("KOALA_APP_ACCESS_TOKEN") { SecureRandom.hex }
  config.app_id           = ENV.fetch("KOALA_APP_ID") { SecureRandom.hex }
  config.app_secret       = ENV.fetch("KOALA_APP_SECRET") { SecureRandom.hex }
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end
