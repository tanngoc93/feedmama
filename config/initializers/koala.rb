# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.access_token = ENV.fetch("KOALA_ACCESS_TOKEN") { nil }
  config.app_access_token = ENV.fetch("KOALA_APP_ACCESS_TOKEN") { nil }
  config.app_id = ENV.fetch("KOALA_APP_ID") { nil }
  config.app_secret = ENV.fetch("KOALA_APP_SECRET") { nil }
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end

# curl -i -X POST "https://graph.facebook.com/?/subscribed_apps?subscribed_fields=feed&access_token=?"
# curl -i -X GET "https://graph.facebook.com/?/subscribed_apps?access_token=?"