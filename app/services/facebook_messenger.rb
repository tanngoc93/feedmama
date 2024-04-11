class FacebookMessenger < ApplicationService
  attr_reader :social_account,
              :sender_id,
              :message

  def initialize(social_account, sender_id, message)
    @social_account = social_account
    @sender_id = sender_id
    @message = message
  end

  def call
    send_message
  end

  private

  def send_message
    return unless social_account.present?

    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{ social_account.resource_id }/messages?access_token=#{ social_account.resource_access_token }",
      headers: headers
    )

    response = conn.post do |req|
      req.body = {
        recipient: {
          id: sender_id
        },
        messaging_type: 'RESPONSE',
        message: {
          text: message
        }
      }.to_json
    end
  end
end
