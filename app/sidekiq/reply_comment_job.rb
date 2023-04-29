class ReplyCommentJob
  include Sidekiq::Job

  KOALA_GPT_TOKEN = ENV.fetch('KOALA_GPT_TOKEN')
  KOALA_PAGE_ACCESS_TOKEN = ENV.fetch('KOALA_PAGE_ACCESS_TOKEN')

  def perform(post_id, comment_id, comment, commentator_name)
    page = Koala::Facebook::API.new( KOALA_PAGE_ACCESS_TOKEN )

    result = ask_gpt(comment, commentator_name)

    page.put_comment(comment_id, result)

    Blocker.find_or_create_by(post_id: post_id, commenter_id: commenter_id)
  end

  private

  def ask_gpt(message = '', commentator_name = '')
    conn = Faraday.new(
      url: 'https://koala.sh/api/gpt/',
      headers: {
        'Authorization': "Bearer #{ KOALA_GPT_TOKEN }",
        'Content-Type': 'application/json'
      }
    )

    input = "Please help me write a creative/engaging comment to reply to this comment #{message}. The commenter's name is #{commentator_name}. \n- Let's analyze the feelings of this comment first. \n- Depend on the emotion of the comment and reply to them with appreciation, gratitude or an empathetic comment. \n- Be kind/energetic and full of love. \n- And if possible choose an icon for the comment you make, it should match the emotion of the comment, for example the comment's emotion is positive, happy should not choose the sad symbol, and vice versa. \n- Make it 10 to 30 words long. \n- If the message is blank or you can't understand the context, give the person a cute song. \n- Note: My Facebook page represents www.AllLoveHere.com, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends. \n- Place the following text at the end to indicate that you are a GPT bot: \" (I'm a Bot. If I make any mistakes, please forgive me. You can find me at www.AllLoveHere.com)\""

    response = conn.post do |req|
      req.body = {
        input: input,
        inputHistory: [],
        outputHistory: [],
        realTimeData: true,
      }.to_json
    end

    puts
    puts
    puts '>>>>> Koala GPT Processing <<<<<'
    puts "status: #{response.status}"
    puts "headers: #{response.headers}"
    puts "comment: #{message}"
    puts "response: #{response.body}"
    puts '>>>>> Koala GPT Processed <<<<<'
    puts
    puts

    JSON.parse(response.body)['output']
  rescue StandardError => e
    Rails.logger.debug(">>>>> #{e.message}")
  end
end
