class OpenaiCreator < ApplicationService
  attr_reader :user_setting,
              :social_account,
              :commentator_name,
              :comment

  def initialize(user_setting, social_account, commentator_name, comment)
    @user_setting = user_setting
    @social_account = social_account
    @commentator_name = commentator_name
    @comment = comment
  end

  def call
    return unless user_setting.present?
    return unless social_account.present?
    return unless openai_client.present?

    response = openai_client.chat(
      parameters: {
        model: user_setting&.api_model,
        messages: [{ role: 'user', content: content_builder }],
        temperature: 0.7,
      }
    )

    content = response.dig('choices', 0, 'message', 'content')

    return false unless content.is_a? String

    content
  end

  private

  def openai_client
    if user_setting&.azure_openai_service?
      OpenAI.configure do |config|
        config.api_type = :azure
        config.uri_base = user_setting&.api_endpoint
        config.api_version = user_setting&.api_version
      end
    end

    OpenAI::Client.new(access_token: user_setting&.api_access_token)
  end

  def content_builder
    content = social_account.openai_prompt_prebuild
    content = content.sub("#comment", comment)
    content = content.sub("#fullName", commentator_name)
    content
  end
end
