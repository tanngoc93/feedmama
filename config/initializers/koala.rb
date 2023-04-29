# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.access_token = ENV.fetch("KOALA_ACCESS_TOKEN") { SecureRandom.hex(10) }
  config.app_access_token = ENV.fetch("KOALA_APP_ACCESS_TOKEN") { SecureRandom.hex(10) }
  config.app_id = ENV.fetch("KOALA_APP_ID") { SecureRandom.hex(10) }
  config.app_secret = ENV.fetch("KOALA_APP_SECRET") { SecureRandom.hex(10) }
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end

# curl -i -X POST "https://graph.facebook.com/?/subscribed_apps?subscribed_fields=feed&access_token=?"
# curl -i -X GET "https://graph.facebook.com/?/subscribed_apps?access_token=?"