class ReplyCommentJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  GPT_TYPE = ENV.fetch('GPT_TYPE') { nil }

  def perform(post_id, comment_id, comment, commentator_name, social_account_id)
    social_account = SocialAccount.where(id: social_account_id).first

    return unless social_account.present?

    content = ask_openai(content = social_account.search_terms, comment, commentator_name)

    page = Koala::Facebook::API.new( social_account.resource_access_token )
    page.put_comment(comment_id, "#{content} ( I'm a Bot. If I make any mistakes, please forgive me. You can find me at www.AllLoveHere.com )")
    page.put_like(comment_id)
  rescue StandardError => e
    Rails.logger.debug(">>>>> ReplyCommentJob:Perform #{e.message}")
  end

  private

  def ask_openai(content, comment, commentator_name)
    client = OpenAI::Client.new

    content = content.sub('#comment', comment)
    content = content.sub('#fullName', commentator_name)

    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: content }],
          temperature: 0.7,
      })

    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    Rails.logger.debug(">>>>> ask_openai: #{e.message}")
  end
end
