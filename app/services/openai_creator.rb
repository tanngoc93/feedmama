class OpenaiCreator < ApplicationService
  attr_reader :app_setting,
              :social_account,
              :commentator_name,
              :comment

  def initialize(app_setting, social_account, commentator_name, comment)
    @app_setting = app_setting
    @social_account = social_account
    @commentator_name = commentator_name
    @comment = comment
  end

  def call
    return unless @app_setting.present?
    return unless @social_account.present?

    response = openai_client.chat(
      parameters: {
        model: app_setting.openai_model,
        messages: [{ role: "user", content: content_builder }],
        temperature: 0.7,
      })

    content = response.dig("choices", 0, "message", "content")

    return false unless content.is_a? String

    "#{content}"
  end

  private

  def content_builder
    content = social_account.search_terms
    content = content.sub('#comment', comment)
    content = content.sub('#fullName', commentator_name)
    content
  end

  def openai_client
    OpenAI.configure do |config|
      config.api_type = app_setting.openai_type.to_sym
      config.api_version = app_setting.openai_api_version
    end

    OpenAI::Client.new(access_token: app_setting.openai_token, uri_base: app_setting.openai_uri)
  end
end
