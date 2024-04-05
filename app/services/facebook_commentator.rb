class FacebookCommentator < ApplicationService
  attr_reader :social_account,
              :comment_id,
              :message

  def initialize(social_account, comment_id, message)
    @social_account = social_account
    @comment_id = comment_id
    @message = message
  end

  def call
    put_comment(@social_account, @comment_id, @message)
  end

  private

  def put_comment(social_account, comment_id, message)
    return unless social_account.present?

    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{ comment_id }/comments",
      headers: headers
    )

    response = conn.post do |req|
      req.body = {
        message: message,
        access_token: social_account.resource_access_token
      }.to_json
    end
  end
end
