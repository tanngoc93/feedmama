class InstagramCommentator < ApplicationService
  attr_reader :social_account,
              :comment_id,
              :message

  def initialize(social_account, comment_id, message)
    @social_account = social_account
    @comment_id = comment_id
    @message = message
  end

  def call
    return unless @social_account.present?

    put_comment(@social_account, @comment_id, @message)
  end

  private

  def put_comment(social_account, comment_id, message)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{comment_id}/replies",
      headers: {
        "Content-Type": "application/json"
      }
    )

    response = conn.post do |req|
      req.body = {
        message: message,
        access_token: social_account.resource_access_token
      }.to_json
    end
  end
end