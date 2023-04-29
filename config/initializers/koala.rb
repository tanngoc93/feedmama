# In Rails, you could put this in config/initializers/koala.rb
Koala.configure do |config|
  config.access_token = ENV.fetch("KOALA_ACCESS_TOKEN")
  config.app_access_token = ENV.fetch("KOALA_APP_ACCESS_TOKEN")
  config.app_id = ENV.fetch("KOALA_APP_ID")
  config.app_secret = ENV.fetch("KOALA_APP_SECRET")
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end

# curl -i -X POST "https://graph.facebook.com/105941988574577/subscribed_apps?subscribed_fields=feed&access_token=EAACrH8WYltMBANzmbnU791hZCyipdoen6tJnENn9HFNjY5P7BG2sdZC7jDmp5VDdLzyf20ZCX5HZA7ExuSoxvo0Ofs5J0Pn1WzbZAArfBqdaKVsm1GKGDfmOVCmbwLPnEZBZAGamKC9YVQpQv2PBDcjOwZAcpNq5SQPZBhH6grp5LMhAm7dWiXXCZANNJRCZBZCAjTSPP7h6wTtrXWr08LqUEr5KU3CZC4YATzREZD"
# curl -i -X GET "https://graph.facebook.com/105941988574577/subscribed_apps?access_token=EAACrH8WYltMBAKHTtZB5C0s2WZCGPuTMZAt32IQsiqjJYvH2dF9ZBDEmb0z4nRY2e9jqQeZB4sWtyYdqLcZAli1YdvVjiDAktxXESkKseZBZCRweJxnyEA4o4ABSyZCbSZANoa1CcmxZBSg0DhpYg1rDeCE9nilfsv8upXbvau6X3FcEDqqu6iYdQyCrdeZAHMW2lTUjLrZBOOWLkMrjzE6zBZBBjZAp2KtZBL0eu2IZD"