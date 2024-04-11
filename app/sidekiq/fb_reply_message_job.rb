class FbReplyMessageJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(sender_id, message, social_account_id, user_setting_id)
    user_setting = UserSetting.find_by(id: user_setting_id, setting_status: :active)
    social_account = SocialAccount.find_by(id: social_account_id, status: true)

    return unless user_setting.present?
    return unless social_account.present?

    message =
      if use_openai?(social_account, message)
        OpenaiCreator.call(
          user_setting, social_account, prompt(message))
      else
        social_account&.random_contents&.sample&.content
      end

    return unless message.is_a? String

    FacebookCommentator.call(social_account, sender_id, message)
  rescue StandardError => e
  end

  private

  def use_openai?(social_account, comment)
    social_account.processing_with_openai &&
      comment.split.size > social_account.minimum_words_required_to_processing_with_openai
  end

  def prompt(message)
    content = "Reply this message from a Facebook user: #{message}"
    content
  end
end
