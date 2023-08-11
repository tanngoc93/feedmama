Koala.configure do |config|
  config.app_id           = ENV.fetch("KOALA_APP_ID") { SecureRandom.hex }
  config.app_secret       = ENV.fetch("KOALA_APP_SECRET") { SecureRandom.hex }
end
