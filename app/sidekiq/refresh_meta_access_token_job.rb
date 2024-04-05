class RefreshMetaAccessTokenJob
  include Sidekiq::Job
  sidekiq_options retry: 1, dead: false

  FACEBOOK_VERSION = ENV.fetch("FACEBOOK_VERSION") { "v16.0" }

  def perform(social_account_id)
    social_account = SocialAccount.find_by(id: social_account_id)

    return unless social_account.present?

    if social_account.facebook? || social_account.instagram?
      social_account&.update(resource_access_token: refresh_access_token(social_account))
    end
  end

  private

  def refresh_access_token(social_account)
    connect = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/oauth/access_token",
      headers: {
        'Content-Type': 'application/json'
      },
      params: {
        grant_type: 'fb_exchange_token',
        client_id: Koala.config.app_id,
        client_secret: Koala.config.app_secret,
        fb_exchange_token: social_account&.resource_access_token
      }
    )

    JSON.parse(connect.get.body)['access_token']
  end
end
