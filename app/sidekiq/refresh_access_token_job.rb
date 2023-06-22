class RefreshAccessTokenJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  FB_VERSION = ENV.fetch('FB_VERSION') { 'v16.0' }

  def perform(id)
    social_account = SocialAccount.find_by(id: id)

    if social_account.present? && social_account.facebook?
      access_token = refresh_token(social_account)

      social_accounts = SocialAccount.where(resource_access_token: social_account.resource_access_token)

      social_accounts&.each do |account|
        account.update(resource_access_token: access_token)
      end
    else
      Rails.logger.debug(">>>>> RefreshAccessTokenJob:Perform AppSetting was not found!")
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>> RefreshAccessTokenJob:Perform #{e.message}")
  end

  private

  def refresh_token(social_account)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{FB_VERSION}/oauth/access_token",
      headers: {
        'Content-Type': 'application/json'
      },
      params: {
        grant_type: 'fb_exchange_token',
        client_id: Koala.config.app_id,
        client_secret: Koala.config.app_secret,
        fb_exchange_token: social_account.resource_access_token
      }
    )

    JSON.parse( conn.get.body )['access_token']
  end
end
