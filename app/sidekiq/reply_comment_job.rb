class ReplyCommentJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(post_id, comment_id, comment, commentator_name, social_account_id, app_setting_id)
    app_setting = AppSetting.where(id: app_setting_id).first
    social_account = SocialAccount.where(id: social_account_id).first

    return unless app_setting.present?
    return unless social_account.present?

    content = ask_openai(app_setting, comment, commentator_name, social_account.search_terms)

    page = Koala::Facebook::API.new( social_account.resource_access_token )
    page.put_comment(comment_id, "#{content} ( I'm a Bot. If I make any mistakes, please forgive me. You can find me at www.AllLoveHere.com )")
    page.put_like(comment_id)
  rescue StandardError => e
    Rails.logger.debug(">>>>> ReplyCommentJob:Perform #{e.message}")
  end

  private

  def ask_openai(app_setting, comment, commentator_name, content)
    client = OpenAI::Client.new( access_token: openai_token.openai_token )

    content = content.sub('#comment', comment)
    content = content.sub('#fullName', commentator_name)

    response = client.chat(
      parameters: {
        model: app_setting.openai_model,
        messages: [{ role: "user", content: content }],
        temperature: 0.7,
      })

    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    Rails.logger.debug(">>>>> ask_openai: #{e.message}")
  end
end
