class OpenaiCreator < ApplicationService
  attr_reader :user_setting,
              :social_account,
              :prompt

  def initialize(user_setting, social_account, prompt)
    @user_setting = user_setting
    @social_account = social_account
  end

  def call
    return unless user_setting.present?
    return unless social_account.present?
    return unless openai_client.present?

    response = openai_client.chat(
      parameters: {
        model: user_setting&.api_model,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.7,
      }
    )

    response_content = response.dig('choices', 0, 'message', 'content')

    return false unless response_content.is_a? String

    response_content
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
end
