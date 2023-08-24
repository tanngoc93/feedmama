class FbReplyCommentJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(post_id, comment_id, comment, commentator_name, social_account_id, app_setting_id)
    app_setting = AppSetting.find_by(id: app_setting_id)
    social_account = SocialAccount.find_by(id: social_account_id)

    return unless app_setting.present?
    return unless social_account.present?

    message =
      if use_openai?(social_account, comment)
        OpenaiCreator.call(app_setting, social_account, commentator_name, comment)
      else
        social_account&.auto_comments&.sample&.content
      end

    return unless message.is_a? String

    FacebookCommentator.call(social_account, comment_id, message)
  rescue StandardError => e
    Rails.logger.debug(">>>>> FbReplyCommentJob:Perform #{e.message}")
  end

  private

  def use_openai?(social_account, comment)
    social_account.use_openai &&
      comment.split.size > social_account.use_openai_when_comment_is_longer_in_length
  end
end
