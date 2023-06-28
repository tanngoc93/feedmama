class InsReplyCommentJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(media_id, comment_id, comment, commentator_name, social_account_id, app_setting_id)
    app_setting = AppSetting.where(id: app_setting_id).first
    social_account = SocialAccount.where(id: social_account_id).first

    return unless app_setting.present?
    return unless social_account.present?

    message =
      if use_openai?(social_account, comment)
        OpenaiCreator.call(app_setting, social_account, commentator_name, comment)
      else
        social_account&.auto_comments&.sample&.content || social_account&.basic_comment
      end

    return unless message.is_a? String

    InstagramCommentator.call(social_account, comment_id, message)
  rescue StandardError => e
    Rails.logger.debug(">>>>> InsReplyCommentJob:Perform #{e.message}")
  end

  private

  def use_openai?(social_account, comment)
    social_account.use_openai && comment.split.size >= social_account.comment_length
  end
end
