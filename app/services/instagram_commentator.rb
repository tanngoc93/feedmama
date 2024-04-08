class InstagramCommentator < ApplicationService
  attr_reader :social_account,
              :comment_id,
              :comment

  def initialize(social_account, comment_id, comment)
    @social_account = social_account
    @comment_id = comment_id
    @comment = comment
  end

  def call
    put_comment
  end

  private

  def put_comment
    return unless social_account.present?

    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{ comment_id }/replies",
      headers: headers
    )

    response = conn.post do |req|
      req.body = {
        message: comment,
        access_token: social_account.resource_access_token
      }.to_json
    end
  end
end