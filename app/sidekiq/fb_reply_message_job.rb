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
        OpenaiCreator.call(user_setting, social_account, prompt(social_account, message))
      end

    return unless message.is_a? String

    response = FacebookMessenger.call(social_account, sender_id, message)

    unless response.status != 200
      social_account.update!(
        status: false,
        service_error_status: true,
        service_error_at: DateTime.now,
        service_error_logs: service_error_logs(social_account, response)
      )
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>>>>>>>>> #{self.class.name} - #{e.message}")
  end

  private

  def use_openai?(social_account, comment)
    social_account.processing_with_openai &&
      comment.split.size > social_account.minimum_words_required_to_processing_with_openai
  end

  def prompt(social_account, message)
    content = social_account.openai_prompt_direct_message_prebuild
    content = content.sub("#message", comment)
    content
  end

  def service_error_logs(social_account, response)
    social_account.service_error_logs << {
      status: response.status,
      body: JSON.parse(response.body)
    }.to_json
  end
end
