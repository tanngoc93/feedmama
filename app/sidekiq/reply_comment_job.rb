class ReplyCommentJob
  include Sidekiq::Job

  KOALA_GPT_TOKEN = ENV.fetch('KOALA_GPT_TOKEN')
  KOALA_PAGE_ACCESS_TOKEN = ENV.fetch('KOALA_PAGE_ACCESS_TOKEN')

  GPT_TYPE = ENV.fetch('GPT_TYPE') { 'KOALA' }

  def perform(post_id, comment_id, comment, commentator_name)
    page = Koala::Facebook::API.new( KOALA_PAGE_ACCESS_TOKEN )

    message = '❤❤❤'

    if GPT_TYPE == 'KOALA'
      message = ask_koala(comment, commentator_name)
    elsif GPT_TYPE == 'OPENAI'
      message = ask_openai(comment, commentator_name)
    end

    page.put_comment(comment_id, "#{message} ( I'm a Bot. If I make any mistakes, please forgive me. You can find me at www.AllLoveHere.com )")
    page.put_like(comment_id)
  rescue StandardError => e
    Rails.logger.debug(">>>>> ReplyCommentJob:Perform #{e.message}")
  end

  private

  def ask_koala(comment = '', commentator_name = '')
    conn = Faraday.new(
      url: 'https://koala.sh/api/gpt/',
      headers: {
        'Authorization': "Bearer #{ KOALA_GPT_TOKEN }",
        'Content-Type': 'application/json'
      }
    )

    input = "Please help me write a creative/engaging comment to reply to this comment #{comment}. The commenter's name is #{commentator_name}. \n- Depend on the emotion of the comment and reply to them with appreciation, gratitude or an empathetic comment. \n- Be kind/energetic and full of love. \n- And if possible choose an icon for the comment you make, it should match the emotion of the comment, for example the comment's emotion is positive, happy should not choose the sad symbol, and vice versa. \n- Make it 10 to 30 words long. \n- If the message is blank or you can't understand the context, give the person a cute song. \n- Note: My Facebook page represents www.AllLoveHere.com, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends."

    response = conn.post do |req|
      req.body = {
        input: input,
        inputHistory: [],
        outputHistory: [],
        realTimeData: false,
      }.to_json
    end

    JSON.parse(response.body)['output']
  rescue StandardError => e
    Rails.logger.debug(">>>>> ask_koala: #{e.message}")
  end

  def ask_openai(comment = '', commentator_name = '')
    client = OpenAI::Client.new

    input = "Please help me write a creative/engaging comment to reply to this comment #{comment}. The commenter's name is #{commentator_name}. \n- Depend on the emotion of the comment and reply to them with appreciation, gratitude or an empathetic comment. \n- Be kind/energetic and full of love. \n- And if possible choose an icon for the comment you make, it should match the emotion of the comment, for example the comment's emotion is positive, happy should not choose the sad symbol, and vice versa. \n- Make it 10 to 30 words long. \n- If the message is blank or you can't understand the context, give the person a cute song. \n- Note: My Facebook page represents www.AllLoveHere.com, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends."

    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: input }],
          temperature: 0.7,
      })

    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    Rails.logger.debug(">>>>> ask_openai: #{e.message}")
  end
end
