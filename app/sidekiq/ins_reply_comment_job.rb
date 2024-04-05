class InsReplyCommentJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(post_id, comment_id, comment, commentator_name, social_account_id, user_setting_id)
    user_setting = AppSetting.find_by(id: user_setting_id)
    social_account = SocialAccount.find_by(id: social_account_id)

    return unless user_setting.present?
    return unless social_account.present?

    message =
      if use_openai?(social_account, comment)
        OpenaiCreator.call(
          user_setting, social_account, commentator_name, comment)
      else
        social_account&.auto_comments&.sample&.content
      end

    return unless message.is_a? String

    InstagramCommentator.call(social_account, comment_id, message)
  rescue StandardError => e
  end

  private

  def use_openai?(social_account, comment)
    social_account.use_openai &&
      comment.split.size > social_account.use_openai_when_comment_is_longer_in_length
  end
end
