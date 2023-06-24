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
        ask_openai(app_setting, comment, commentator_name, social_account.search_terms)
      else
        if social_account.auto_comments.any?
          social_account.auto_comments.sample.content
        else
          social_account.basic_comment
        end
      end

    return unless message.is_a? String

    conn = Faraday.new(
      url: "https://graph.facebook.com/#{comment_id}/replies",
      headers: {
        'Content-Type': 'application/json'
      }
    )

    response = conn.post do |req|
      req.body = {
        message: message,
        access_token: social_account.resource_access_token
      }.to_json
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>> InsReplyCommentJob:Perform #{e.message}")
  end

  private

  def use_openai?(social_account, comment)
    social_account.use_openai && comment.split.size >= social_account.comment_length
  end

  def ask_openai(app_setting, comment, commentator_name, content)
    set_openai_config(app_setting)

    client = OpenAI::Client.new(
      access_token: app_setting.openai_token,
      uri_base: app_setting.openai_uri
    )

    content = content.sub('#comment', comment)
    content = content.sub('#fullName', commentator_name)

    response = client.chat(
      parameters: {
        model: app_setting.openai_model,
        messages: [{ role: "user", content: content }],
        temperature: 0.7,
      })

    result = response.dig("choices", 0, "message", "content")

    return false unless result.is_a? String

    "#{result} (I'm a Bot, kindly overlook any mistakes I make. Come find me at www.AllLoveHere.com)"
  rescue StandardError => e
    Rails.logger.debug(">>>>> InsReplyCommentJob:AskOpenAI: #{e.message}")
  end

  def set_openai_config(app_setting)
    OpenAI.configure do |config|
      config.api_type = app_setting.openai_type.to_sym
      config.api_version = app_setting.openai_api_version
    end
  end
end
