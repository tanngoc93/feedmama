class RefreshAccessTokenJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  FB_VERSION = ENV.fetch('FB_VERSION') { 'v16.0' }

  def perform(id)
    social_account = SocialAccount.find_by(id: id)

    if social_account.present?
      social_account.update!(access_token: refresh_token(social_account))
    else
      Rails.logger.debug(">>>>> RefreshAccessTokenJob:Perform AppSetting was not found!")
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>> RefreshAccessTokenJob:Perform #{e.message}")
  end

  private

  def refresh_token
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{FB_VERSION}/oauth/access_token",
      headers: {
        'Content-Type': 'application/json'
      },
      params: {
        grant_type: 'fb_exchange_token',
        client_id: Koala.config.app_id,
        client_secret: Koala.config.app_secret,
        fb_exchange_token: 'EAACrH8WYltMBAFiFd4m4XZBzfIUTulpEzxIakA2uMHVNQH2IlCkhWpzUulQy8kZCYpfVcZBTQNjel1qZAFuy73f9fHAZBZA2Tx6nmIxiriu0g4AuakZBL9adagzN7KZBkkXPTdFn7ajS0fpVSuEPO0ZCTw2jWkKHXLZBE8SCuYAvBLH3PhinZBwbZAho8pHf5MvFZBzo84Rd6kOb8ygZDZD'
      }
    )

    JSON.parse( conn.get.body )['access_token']
  end
end
