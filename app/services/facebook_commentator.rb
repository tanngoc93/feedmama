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
    return unless @social_account.present?

    page = Koala::Facebook::API.new( @social_account.resource_access_token )
    page.put_comment(@comment_id, @message)
    page.put_like(@comment_id)
  end
end
