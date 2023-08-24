Koala.configure do |config|
  config.app_id     = ENV.fetch("FACEBOOK_APP_ID") { SecureRandom.hex }
  config.app_secret = ENV.fetch("FACEBOOK_APP_SECRET") { SecureRandom.hex }
end
