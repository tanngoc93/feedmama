class FacebookCommenter < ApplicationService
  attr_reader :social_account,
              :comment_id,
              :comment

  def initialize(social_account, comment_id, comment)
    @social_account = social_account
    @comment_id = comment_id
    @comment = comment
  end

  def call
    put_like
    put_comment
  end

  private

  def put_like
    return unless social_account.present?

    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{ comment_id }/likes",
      headers: headers
    )

    response = conn.post do |req|
      req.body = {
        access_token: social_account.resource_access_token
      }.to_json
    end
  end

  def put_comment
    return unless social_account.present?

    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{ '497169726156773_1012898640575492' }/comments",
      headers: headers
    )

    response = conn.post do |req|
      req.body = {
        message: 'hello',
        access_token: access_token
      }.to_json
    end
  end
end
